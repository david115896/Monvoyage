class OrganisersController < ApplicationController
  before_action :set_organiser, only: [:show, :edit, :update, :destroy]
	before_action :check_organiser, only: [:new, :edit]


  def new
	
		if session[:current_day] == nil
			session[:current_day] = 1
		end
			
		if params[:commit] == "change"
			cookies[:organiser_id] = params[:id]
			session[:current_day] = 1
		end

		if params[:commit] == "day"
			session[:current_day] = params[:organiser][:duration].to_i
		end

		@unselected_checkouts = set_unselected_checkouts(set_checkouts)
		@selected_checkouts = set_selected_checkouts(set_checkouts)
		@city = current_city
		@organiser = first_organiser
		gon.city = City.find(current_city.id)

		#tempo !!
		@cart_activities = set_my_activities
		@selected_activities = set_selected_activities(set_checkouts)
		gon.organiser_activities = @selected_activities

  end

	def create

		if user_signed_in?

			organiser = Organiser.new(user: current_user, city_id: params[:city][:id], duration: 1)
			if organiser.save
				cookies.permanent[:organiser_id] = organiser.id
				redirect_to city_activities_path(params[:city][:id])
			end

		else

			cookies.permanent[:tempo_organiser] = JSON.generate({city_id: params[:city][:id], duration: 1, checkouts: Hash.new})
			redirect_to city_activities_path(params[:city][:id])

		end
	end

  def edit
		
		cookies[:organiser_id] = Organiser.maj_organiser(params, current_organiser.id)
		session[:current_day] = current_organiser.maj_day(params, session[:current_day])

		@unselected_checkouts = get_unselected_checkouts
		@selected_checkouts = get_selected_checkouts
		@cart_activities = get_my_activities

		@selected_activities = Checkout.selected_activities(cookies[:organiser_id])
		gon.organiser_activities = Checkout.selected_activities(cookies[:organiser_id])
		gon.city = current_city.id

  end

	def update

		organiser = Organiser.find(cookies[:organiser_id])
		organiser.duration = params[:organiser][:duration]

		if organiser.save
			session[:current_day] = 1
			current_organiser.reset_checkouts
			redirect_to edit_organiser_path(organiser.id)
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
