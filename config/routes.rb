Rails.application.routes.draw do

  get 'static/index'
  root :to => "static#index"
  
  devise_for :users

end
