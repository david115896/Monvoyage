class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]

  def index
    if user_signed_in?
      @cart_activities = Activity.list_cart(current_user)
    else
      @cart_activities = Activity.list_cookie(JSON.parse(cookies[:activities]))
    end
  end

  def show
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
          format.html { redirect_to city_path(params[:city_id]), flash: { success: 'Activities was successfully added to your cart.'}}
        else
          format.html { render :new }
          format.json { render json: @cart.errors, status: :unprocessable_entity }
        end
      end
    else
      if cookies[:activities] == nil
        cookies[:activities] = JSON.generate([Activity.find(params[:activity_id]).id])
      else
        cookies[:activities] = JSON.generate(JSON.parse(cookies[:activities]) + [Activity.find(params[:activity_id]).id])
      end
      respond_to do |format|
        format.html { redirect_to city_path(params[:city_id]),flash: { success: 'Activities was successfully added to your cart.'} }
      end
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
      format.html { redirect_to carts_url, flash: { success: 'Activity was successfully removed from planning.' }}
      format.json { head :no_content }
    end
  end

  def destroy_activities_cookie
    new_array = Array.new
    array = JSON.parse(cookies[:activities])
    array.each do |activity_id|
      if activity_id != params[:activity_id].to_i
        new_array << activity_id
      end
    end
    cookies[:activities] = JSON.generate(new_array)
    redirect_to carts_path, flash: { success: 'Activity was successfully removed from planning.' }
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
