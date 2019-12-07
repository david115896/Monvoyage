class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]

  def index
    @cities = City.all
  end

  def show
	 	if params[:commit] == "Go"
			@city = City.find(params[:city][:id])
			redirect_to city_url(@city.id)
		elsif params[:commit] == "Search"
			cat = params[:city][:activities_category_id]
			@activities = Activity.where(city: @city,activities_category_id: cat)
		else
			@activities = Activity.where(city: @city, activities_category_id: ActivitiesCategory.where(name: "Landmarks").first)
		end
			@activities_categories = ActivitiesCategory.all
			@city = City.find(params[:id])
      gon.city_activities = @activities
      if user_signed_in?
        @carts = Cart.where(user_id: current_user.id)
      elsif cookies[:activities] != nil
        @carts = JSON.parse(cookies[:activities])
      else 
        @carts = Array.new
      end
      if user_signed_in?
        @cart_activities = Activity.list_cart(current_user)
      elsif cookies[:activities] != nil
        @cart_activities = Activity.list_cookie(JSON.parse(cookies[:activities]))
      else
        @cart_activities = Array.new
      end
  end

  def new
    @city = City.new
  end

  def edit
  end

  def create
    @city = City.new(city_params)

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @city }
      else
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { render :show, status: :ok, location: @city }
      else
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @city.destroy
    respond_to do |format|
      format.html { redirect_to cities_url, notice: 'City was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:name, :address, :climat, :description, :time_zone, :traditions, :flag, :picture, :emblems)
    end
end
