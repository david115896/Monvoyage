Rails.application.routes.draw do
  resources :countries
  get 'static/index'
  root :to => "static#index"
end
