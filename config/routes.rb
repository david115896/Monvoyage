Rails.application.routes.draw do
  resources :activities
  resources :carts
  devise_for :users
	 resources :users, except:[:index, :new, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :countries
  get 'static/index'
  root :to => "static#index"
  resources :charges
end
