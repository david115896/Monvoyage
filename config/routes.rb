Rails.application.routes.draw do
  
  #statics views
  root :to => "static#index"
  get 'static/index'

  # mains tables
  devise_for :users
	resources :users, except:[:index, :new, :create]
  resources :cities do
		resources :activities do
			collection { post :import}
		end
	end 
  resources :countries
  resources :tickets

  #joints tables 
  resources :carts, only: [:index, :create, :destroy]
  resources :organizers, only: [:index, :create, :destroy]
  resources :orders, only: [:index, :create, :destroy]

  #service
  resources :charges #stripe

end
