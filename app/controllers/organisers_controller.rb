class OrganisersController < ApplicationController
  before_action :set_organiser, only: [:show, :edit, :update, :destroy]


  def show
		if user_signed_in?
			@organiser = Organiser.find(cookies[:organiser_id])
			@tickets = @organiser.tickets
		else
			@tickets = parse_tickets
		end
  end

  def new
		@tickets = set_tickets
		@checkouts = set_checkouts
    gon.organiser_activities = @cart_activities
  end

	def create

		if user_signed_in?
			organiser = Organiser.new(user: current_user, city_id: params[:organiser][:city_id])
			if organiser.save
				cookies.permanent[:organiser_id] = organiser.id
				redirect_to city_activities_path(params[:organiser][:city_id])
			end
		else
			cookies.delete :tempo_organiser
			cookies.permanent[:tempo_organiser] = JSON.generate({city_id: params[:organiser][:city_id], checkouts: []})
			puts cookies[:tempo_organiser]
			redirect_to city_activities_path(params[:organiser][:city_id])
		end
	end

  def edit

		if params[:commit] == "change"
			cookies[:organiser_id] = params[:id]
		end

		@unselected_checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: false)
		@selected_checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: true)
    gon.organiser_activities = @cart_activities

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

		def set_checkouts
			hash = JSON.parse cookies[:tempo_organiser]
			return hash["checkouts"]
		end

		def set_tickets
			tickets = []
			hash = JSON.parse cookies[:tempo_organiser]
			for checkout in hash["checkouts"] do
				tickets << Ticket.find(checkout["ticket_id"])
			end
			return tickets
		end

end
