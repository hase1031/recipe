class HomeController < ApplicationController

  def index
    @recipes = Recipe.latest.page(params[:page])
  end

end