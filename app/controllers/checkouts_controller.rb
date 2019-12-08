class CheckoutsController < ApplicationController
  before_action :set_checkout, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, except: [:create, :update]

  def index
		@checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: true)
    @amount = 42 
  end

  def create
		activity = Activity.find(params[:activity_id])
		ticket = activity.tickets.first	 
		if user_signed_in?
			checkout = Checkout.new(organiser_id: cookies[:organiser_id], ticket_id: ticket.id, selected: false)
			if checkout.save
				redirect_to city_activities_path(activity.city), notice: 'Checkout was successfully created.'
			end
		else
			hash = JSON.parse cookies[:tempo_organiser]
			hash["checkouts"] << {:ticket_id => ticket.id, :selected => false} 
			cookies[:tempo_organiser] = JSON.generate hash
			redirect_to city_activities_path(activity.city), notice: 'Checkout was successfully created.'
		end
	end     

  def update

			checkout = Checkout.find(params[:id])
		if user_signed_in?
			if params[:commit] == "select"
				checkout.selected = true
			else
				checkout.selected = false
			end
			if checkout.save
				redirect_to edit_organiser_path(cookies[:organiser_id])
			end
		else
			update_checkout(params[:index].to_i)
			redirect_to new_organiser_path
		end
  end

  def destroy
    @checkout.destroy
  end

  private

		def update_checkout(index)
			if params[:commit] == "select"
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
      @checkout = Checkout.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkout_params
      params.fetch(:checkout, {})
    end
end
