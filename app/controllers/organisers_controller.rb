class OrganisersController < ApplicationController
  	before_action :set_organiser, only: [:show, :edit, :update, :destroy]
	before_action :check_organiser, only: [:new, :edit]
	before_action :authenticate_user, only: [:edit]

	def show
		if user_signed_in?
				@organiser = Organiser.find(cookies[:organiser_id])
				@checkouts = @organiser.checkouts
		else
				@tickets = parse_tickets
				hash = JSON.parse cookies[:tempo_organiser]
		end
		@checkout = Checkout.find(params[:checkout_id])
		@tickets = Ticket.where(activity: @checkout.ticket.activity)
		respond_to do |format|
			format.html 
			format.js
		end
	end


	def create

		if user_signed_in?
			organiser = Organiser.new(user: current_user, city_id: params[:city][:id], duration: 1)
			if organiser.save
				cookies.permanent[:organiser_id] = organiser.id
			end
		else
			cookies.permanent[:tempo_organiser] = JSON.generate({city_id: params[:city][:id], duration: 1, checkouts: Hash.new})
		end
		redirect_to city_activities_path(params[:city][:id],city: {:id => current_city.id})
	end

	def edit

		cookies[:organiser_id] = Organiser.update(params, current_organiser.id)
		session[:current_day] = current_organiser.day_update(params, session[:current_day])
		@unselected_checkouts = Checkout.get_unselected_checkouts(current_organiser.id)
		@selected_checkouts = Checkout.get_selected_checkouts(current_organiser.id)
		@cart_activities = Activity.get_my_activities(Checkout.get_checkouts_id(current_organiser.checkouts))
		@selected_activities = Checkout.selected_activities(cookies[:organiser_id], session[:current_day])
		gon.organiser_activities = @selected_activities
		gon.city = current_city

	end

	def update

		organiser = Organiser.find(cookies[:organiser_id])
		organiser.duration = params[:organiser][:duration]
		if organiser.save
			session[:current_day] = 1
			current_organiser.reset_checkouts
			redirect_to edit_organiser_path(organiser.id)
		end
		if params[:commit] == "change_nb_days"
			current_organiser.reset_checkouts
		end
		
	end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organiser
      @organiser = Organiser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organiser_params
      params.fetch(:organiser, {})
    end

	def check_organiser
		if !current_organiser?
			flash[:info] = "Choose your city"
			redirect_to cities_path
		end
	end


		
end
