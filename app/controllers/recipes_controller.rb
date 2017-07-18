class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :destroy]

  def new
    @recipe = current_user.recipes.build
    build_children
  end

  def create
    @recipe = Recipe.new
    assign_attributes
    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      build_children
      flash.now[:alert] = 'レシピの保存に失敗しました。'
      render :new
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    build_children
  end

  def update
    @recipe = Recipe.find(params[:id])
    assign_attributes
    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      build_children
      render :edit
    end
  end

  def destroy
    Recipe.find(params[:id]).destroy
  end

  def show
    @recipe = Recipe.includes(:tags).find(params[:id]).decorate
    tag_ids = @recipe.tags.map(&:id)
    related = RecipeTag.joins(:recipe)
                  .merge(Recipe.current_published)
                  .where(tag_id: tag_ids)
                  .group(:recipe_id)
                  .order('count_tag_id DESC')
                  .limit(11) #10件表示
                  .count(:tag_id)
                  .keys
    related.delete(@recipe.id)
    @related_recipes = Recipe.find(related)
  end

  private

  def recipe_params
    params.require(:recipe).permit(
        :title,
        :description,
        :video,
        :prep_time,
        :cook_time,
        :total_time,
        :recipe_yield,
        :user_id,
        :markdown,
        tags_attributes: [
            :id,
            :name,
        ],
        ingredients_attributes: [
            :id,
            :name,
            :volume,
        ],
    )
  end

  def assign_attributes
    if params[:publish].present?
      @recipe.status = :published
      @recipe.published_at = Time.now
    else
      @recipe.status = :editing
      @recipe.published_at = nil
    end
    params[:recipe][:tags_attributes] = params[:recipe][:tags_attributes].select { |key, value|
      value['name'].present? or value['id'].present?
    }
    params[:recipe][:ingredients_attributes] = params[:recipe][:ingredients_attributes].select { |key, value|
      value['name'].present? and value['volume'].present? or value['id'].present?
    }
    @recipe.assign_attributes(recipe_params)
    @recipe.tags = @recipe.tags.select { |tag| tag.name.present? }.map { |tag| Tag.find_or_create_by(name: tag.name) }
    @recipe.ingredients.each do |ingredient|
      ingredient.mark_for_destruction if ingredient.name.blank? or ingredient.volume.blank?
    end
  end

  def build_children
    10.times do
      @recipe.ingredients.build
    end
    (10 - @recipe.tags.size).times do
      @recipe.tags.build
    end
  end
end