Rails.application.routes.draw do

  #statics views
  root :to => "static#index"
  get 'static/index'

  # mains tables
  devise_for :users
  resources :users, except:[:index, :new, :create]
  resources :tickets
  resources :countries

  resources :cities do
		resources :activities do
			collection { post :import}
		end
	end 
	
	namespace :admin do
		resources :users
		resources :orders
		resources :activities
  end
  resources :organisers do
    collection { delete :destroy_ticket_cookie}
    collection { post :validate_organiser}
  end

  #joints tables 
  resources :carts, only: [:index, :create, :destroy] do
    collection { delete :destroy_activities_cookie}
  end
  resources :organizers, only: [:index, :create, :destroy]
  resources :orders, only: [:index, :create, :destroy, :show]
  resources :sold_tickets, only: [:index, :create, :destroy]
  resources :checkouts, only: [:index, :create, :destroy]

  #service
  resources :charges #stripe

end
