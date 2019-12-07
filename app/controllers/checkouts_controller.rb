class CheckoutsController < ApplicationController
  before_action :set_checkout, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user

  def index
    @checkouts = Checkout.where(user_id: current_user.id)
    @amount = Checkout.amount(current_user).to_i
      
  end

  def show
  end

  def new
    @checkout = Checkout.new
  end

  def edit
  end

  def create
    Checkout.add_tickets(current_user)
		redirect_to checkouts_path

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
