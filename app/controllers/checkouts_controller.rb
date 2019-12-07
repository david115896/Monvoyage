class CheckoutsController < ApplicationController
  before_action :set_checkout, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user

  def index

		@checkouts = Checkout.where(organiser_id: params[:id])
           @amount = Checkout.amount(@checkouts).to_i
           session[:organiser_id] = params[:id]
      
  end

  def show
  end

  def new
    @checkout = Checkout.new
  end

  def edit
  end

  def create
		activity = Activity.find(params[:activity_id])
		ticket = activity.tickets.first	 
		@checkout = Checkout.new(organiser_id: cookies[:organiser_id], ticket_id: ticket.id)
		if @checkout.save
			redirect_to city_activities_path(activity.city), notice: 'Checkout was successfully created.'
		end
	end     



  def update
    respond_to do |format|
      if @checkout.update(checkout_params)
        format.html { redirect_to @checkout, notice: 'Checkout was successfully updated.' }
        format.json { render :show, status: :ok, location: @checkout }
      else
        format.html { render :edit }
        format.json { render json: @checkout.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @checkout.destroy
    redirect_to checkouts_path, flash: { danger: 'Ticket has been removed from your checkout.'}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_checkout
      @checkout = Checkout.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def checkout_params
      params.fetch(:checkout, {})
    end
end
