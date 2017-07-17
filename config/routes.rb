Rails.application.routes.draw do
  devise_for :users, :controllers => {registrations: 'users/registrations', sessions: 'users/sessions'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope '/', controller: :home do
    root 'home#index'
  end
  resources :recipes
  namespace :users do
    resources :recipes, only: %i[index]
  end
end
