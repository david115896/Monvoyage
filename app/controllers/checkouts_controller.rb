class CheckoutsController < ApplicationController
  before_action :set_checkout, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, except: [:create, :update, :destroy]

  def index
		@checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: true, paid: false)
    	@amount = Checkout.amount(@checkouts)
  end

  def create
		@activity = Activity.find(params[:activity_id])
		ticket = @activity.tickets.first	 
		if user_signed_in?

			checkout = Checkout.new(organiser_id: cookies[:organiser_id], ticket_id: ticket.id, selected: false, paid: false)
			if checkout.save
				respond_to do |format|
					format.html {redirect_to city_activities_path(@activity.city), notice: 'Checkout was successfully created.'}
					format.js
				end
			end

		else
			hash = JSON.parse cookies[:tempo_organiser]
			hash["checkouts"][set_rank] = {:ticket_id => ticket.id, :selected => false, :day => 0, :index => 0}
			cookies[:tempo_organiser] = JSON.generate hash
			respond_to do |format|
				format.html {redirect_to city_activities_path(@activity.city), notice: 'Checkout was successfully created.'}
				format.js
			end
		end

	end     

  def update

		checkout = Checkout.update(checkout, params, session[:current_day])

		if checkout
			update_ajax
			respond_to do |format|
				format.html {redirect_to edit_organiser_path(cookies[:organiser_id])}
				format.js
			end
		end

	end

  def destroy
		if user_signed_in?

			@activity = @checkout.ticket.activity
			@checkout.destroy

		else

			@activity = get_activity_session(params[:rank])
			checkout_destroy_session(params[:rank])

		end

	respond_to do |format|
		format.html {(redirect_to city_activities_path(current_city.id))}
		format.js
		end
  end

  private



	def update_ajax
		@unselected_checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: false).order(:index)
		@selected_checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: true).order(:index)
		@organiser = Organiser.find(cookies[:organiser_id])
		@city = @organiser.city
		#tempo !!
		@selected_activities = Checkout.selected_activities(cookies[:organiser_id]).to_json
		
	end


    # Use callbacks to share common setup or constraints between actions.
    def set_checkout
			if user_signed_in?
				@checkout = Checkout.find(params[:id])
			end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkout_params
      params.fetch(:checkout, {})
    end
end
