Rails.application.routes.draw do


  resources :cities
  get 'static/index'
  root :to => "static#index"

  devise_for :users

end
