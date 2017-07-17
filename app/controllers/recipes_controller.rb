class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :destroy]

  def new
    @recipe = current_user.recipes.build
    20.times do
      @recipe.ingredients.build
    end
  end

  def create
    @recipe = Recipe.new(recipe_params)
    assign_attributes
    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      flash.now[:alert] = 'レシピの保存に失敗しました。'
      render :new
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    10.times do
      @recipe.ingredients.build
    end
  end

  def update
    @recipe = Recipe.find(params[:id])
    assign_attributes
    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      render :edit
    end
  end

  def destroy
    Recipe.find(params[:id]).destroy
  end

  def show
    @recipe = Recipe.find(params[:id]).decorate
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
    end
    params[:recipe][:ingredients_attributes] = params[:recipe][:ingredients_attributes].select { |key, value|
      value['name'].present? and value['volume'].present?
    }
    @recipe.assign_attributes(recipe_params)
    @recipe.ingredients.each do |ingredient|
      ingredient.mark_for_destruction if ingredient.name.blank? or ingredient.volume.blank?
    end
  end

end