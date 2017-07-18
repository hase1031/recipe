class HomeController < ApplicationController

  def index
    @recipes = Recipe.current_published.latest.page(params[:page])
  end

end