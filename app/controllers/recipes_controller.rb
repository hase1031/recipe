class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :destroy]

  def new
    @recipe = current_user.recipes.build
  end

  def create
    @recipe = Recipe.new(recipe_params)
    prepare_for_publish
    if @recipe.save
      redirect_to recipe_path(@recipe)
    else
      flash.now[:alert] = 'レシピの保存に失敗しました。'
      render :new
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    prepare_for_publish
    if @recipe.update(recipe_params)
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
    )
  end

  def prepare_for_publish
    @recipe.status = :published
    @recipe.published_at = Time.now if params[:publish].present?
  end

end