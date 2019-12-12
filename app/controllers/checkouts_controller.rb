class CheckoutsController < ApplicationController
  before_action :set_checkout, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, except: [:create, :update]

  def index
		@checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: true)
    @amount = 42 
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
			hash["checkouts"] << {:ticket_id => ticket.id, :selected => false} 
			cookies[:tempo_organiser] = JSON.generate hash
			respond_to do |format|
				format.html {redirect_to city_activities_path(@activity.city), notice: 'Checkout was successfully created.'}
				format.js
			end
		end
	end     

  def update

		checkout = Checkout.find(params[:id])
		
		if user_signed_in?
			if params[:commit] == "up"
				swap_up(checkout)	
			end

			if params[:commit] == "down"
				swap_down(checkout)	
			end

			if params[:commit] == "change"
				checkout = Checkout.find(params[:ticket][:checkout_id])
				ticket = Ticket.find(params[:ticket][:id])
				checkout.ticket_id = ticket.id	
			end

			if params[:commit] == "Select this ticket"
				checkout.selected = true
				checkout.day = session[:current_day]
				checkout.index = set_index(checkout)
				checkout.ticket_id = params[:ticket][:id]
			end

			if params[:commit] == "unselect"
				Checkout.update_index_after_unselect(@checkout)
				checkout.selected = false
				checkout.day = nil
				checkout.index = nil
			end

			if checkout.save
				update_ajax
				respond_to do |format|
					format.html {redirect_to edit_organiser_path(cookies[:organiser_id])}
					format.js
				end
			end

		else
			update_checkout(params[:index].to_i)
			update_ajax
			respond_to do |format|
				format.html {redirect_to new_organiser_path}
				format.js
			end
		end
  end

  def destroy
	@activity = @checkout.ticket.activity
	@checkout.destroy
	respond_to do |format|
		format.html {(redirect_to city_activities_path(current_city_id))}
		format.js
	end
  end

  private

	def update_checkout(index)
		if params[:commit] == "Select this ticket"
			hash = JSON.parse cookies[:tempo_organiser]
			checkout = hash["checkouts"][index]  
			checkout["selected"] = true
			cookies[:tempo_organiser] = JSON.generate hash
		else
			hash = JSON.parse cookies[:tempo_organiser]
			checkout = hash["checkouts"][index]  
			checkout["selected"] = false
			cookies[:tempo_organiser] = JSON.generate hash
		end

	end


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
      @checkout = Checkout.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkout_params
      params.fetch(:checkout, {})
    end
end
