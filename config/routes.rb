Rails.application.routes.draw do

	resources :activities do
    collection { post :import}
  end

  resources :orders
  resources :tickets
  root :to => "static#index"
  get 'static/index'

  devise_for :users

	resources :users, except:[:index, :new, :create]
  resources :cities
  resources :activities
  resources :carts
  resources :countries
  resources :charges
	
end
