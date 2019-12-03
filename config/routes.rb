Rails.application.routes.draw do
  resources :countries, only: [:new, :update, :destroy, :edit :]
  get 'static/index'
  root :to => "static#index"

end
