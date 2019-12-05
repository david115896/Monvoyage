class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]


  def index
    @carts = Cart.all
  end

  def show
    @cart_activities = Cart.where(user_id: current_user.id)
  end

  def new
    @cart = Cart.new
  end

  def edit
  end

  def create
    if user_signed_in?
      @cart = Cart.new
      @cart.user_id = current_user.id
      @cart.activity_id = Activity.find(params[:activity_id]).id
      respond_to do |format|
        if @cart.save
          format.html { redirect_to cities_path("55"), flash: { success: 'Activities was successfully added to your cart.'}}
        else
          format.html { render :new }
          format.json { render json: @cart.errors, status: :unprocessable_entity }
        end
      end
    else
     # current_activities = JSON.parse(cookies[:activities])
     # current_activities << ["1"]
     # cookies[:activities] = JSON.generate(current_activities)


    cookies[:activities] = JSON.generate(JSON.parse(cookies[:activities]) + [Activity.find(params[:activity_id]).id])
    respond_to do |format|
    format.html { redirect_to city_path("55"),flash: { success: 'Activities was successfully added to your cart.'} }
    end
    #  cookies[:activities] = JSON.generate([Activity.first.id, Activity.second.id])
    end

   
  end

  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.fetch(:cart, {}).permit(:activity_id)
    end
end
