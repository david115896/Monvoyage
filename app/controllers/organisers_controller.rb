class OrganisersController < ApplicationController
  before_action :set_organiser, only: [:show, :edit, :update, :destroy]
	before_action :check_organiser, only: [:new, :edit]

  def index
    if user_signed_in?
      if cookies[:organiser] != nil
        Organiser.put_cookies_in_table(current_user, JSON.parse(cookies[:organiser]))
        cookies.delete(:organiser)
      end
      @cart_activities = Activity.list_cart(current_user)
      @organisers_tickets = Organiser.list_organiser(current_user)
      gon.organiser_activities = @cart_activities

    else
      if cookies[:activities] != nil
        @cart_activities = Activity.list_cookie(JSON.parse(cookies[:activities]))
        gon.organiser_activities = @cart_activities

      else
        @cart_activities = Array.new
      end

      if cookies[:organiser] != nil
        @organisers_tickets = Organiser.list_cookie(JSON.parse(cookies[:organiser]))
      else
        @organisers_tickets = Array.new
      end
    end  
    session[:show_itinerary] = false
  end

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
		
		if session[:current_day] == nil
			session[:current_day] = 1
		end
			
		if params[:commit] == "change"
			cookies[:organiser_id] = params[:id]
			session[:current_day] = 1
		end

		if params[:day] 
			session[:current_day] = params[:day].to_i
		end

		# if params[:day] == "day"
		# 	session[:current_day] = params[:day]
		# end

		@unselected_checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: false).order(:index)
		@selected_checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: true).order(:index)
		@organiser = Organiser.find(cookies[:organiser_id])
		@city = @organiser.city
		gon.city = City.find(@organiser.city.id)

		#tempo !!
		@cart_activities = set_activities(Checkout.where(organiser_id: cookies[:organiser_id]))
		gon.organiser_activities = Checkout.selected_activities(cookies[:organiser_id])
		@selected_activities = Checkout.selected_activities(cookies[:organiser_id])
  end

	def update
		organiser = Organiser.find(cookies[:organiser_id])
		organiser.duration = params[:organiser][:duration]
		if organiser.save
			session[:current_day] = 1
			reset_checkouts
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

		def parse_tickets
			hash = JSON.parse cookies[:tempo_organiser]
			tickets = []
			for checkout in hash["checkouts"] do
				tickets <<	Ticket.find(checkout["ticket_id"])
			end

			return tickets
		end



		def set_activities (checkouts)
			activities = []
			for checkout in checkouts do
				activities << checkout.ticket.activity
			end
			return activities
		end

		def reset_checkouts
			checkouts = Checkout.where(organiser_id: cookies[:organiser_id], paid: false)
			for checkout in  checkouts do
				checkout.selected = false	
				checkout.index = nil
			end
		end
			
		def check_organiser
			if !current_organiser?
				flash[:info] = "Choose your city"
				redirect_to cities_path
			end
		end
		
end
