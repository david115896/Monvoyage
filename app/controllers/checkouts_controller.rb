class CheckoutsController < ApplicationController
  before_action :set_checkout, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, except: [:create, :update, :destroy]

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
			hash["checkouts"][set_rank] = {:ticket_id => ticket.id, :selected => false, :day => 0, :index => 0}
			cookies[:tempo_organiser] = JSON.generate hash
			respond_to do |format|
				format.html {redirect_to city_activities_path(@activity.city), notice: 'Checkout was successfully created.'}
				format.js
			end
		end
	end     

  def update


		if user_signed_in?

		checkout = Checkout.find(params[:id])

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

			if params[:commit] == "Select this activity"
				
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
				redirect_to edit_organiser_path(cookies[:organiser_id])
			end

		else
			
			if params[:commit] == "up"
				hash = JSON.parse cookies[:tempo_organiser]
				rank = params[:id]
				checkout = hash["checkouts"][rank]
				swap_up({rank => checkout})	
			end

			if params[:commit] == "down"
				hash = JSON.parse cookies[:tempo_organiser]
				rank = params[:id]
				checkout = hash["checkouts"][rank]
				swap_down({rank => checkout})	
			end

			if params[:commit] == "change"
				checkout = Checkout.find(params[:ticket][:checkout_id])
				ticket = Ticket.find(params[:ticket][:id])
				checkout.ticket_id = ticket.id	
			end

			if params[:commit] == "Select this activity"
				
				rank = params["ticket"]["rank"]
				hash = JSON.parse cookies[:tempo_organiser]
				hash["checkouts"][rank]["selected"] = true
				hash["checkouts"][rank]["ticket_id"] = params[:ticket][:id]
				hash["checkouts"][rank]["day"] = session[:current_day]
				hash["checkouts"][rank]["index"] = last_index + 1
				cookies[:tempo_organiser] = JSON.generate hash
				
			end

			if params[:commit] == "unselect"
				update_checkouts_after_unselect(params[:id])
			end


			redirect_to new_organiser_path
		end
  end

  def destroy
		if user_signed_in?
			@activity = @checkout.ticket.activity

			@checkout.destroy

		else
			hash = JSON.parse cookies[:tempo_organiser]
			hash["checkouts"].delete(params[:id])
			cookies[:tempo_organiser] = JSON.generate hash	
		end

	respond_to do |format|
		form.html {redirect_to city_activities_path(current_city_id)}
		format.js
		end
  end

  private

		def update_checkout(index)
			if params[:commit] == "Select this activity"
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
