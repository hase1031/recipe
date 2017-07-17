class Users::RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes = Recipe.where(user_id: current_user.id).order(id: :desc).page(params[:page])
  end

end