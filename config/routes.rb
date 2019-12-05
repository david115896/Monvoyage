Rails.application.routes.draw do


  resources :sold_tickets
  resources :orders
  resources :tickets
  root :to => "static#index"
  get 'static/index'

  devise_for :users

	resources :users, except:[:index, :new, :create]

  resources :cities do
		resources :activities do
			collection { post :import}
		end
	end
	
  resources :carts
  resources :countries
  resources :charges
	
end
