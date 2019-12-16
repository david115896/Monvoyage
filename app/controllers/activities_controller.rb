class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
	before_action :check_organiser, only: [:index]

  def index

		if user_signed_in?
			@activities = Activity.update(params, Checkout.get_checkouts_id(current_organiser.checkouts))
			@cart_activities = Activity.get_my_activities(Checkout.get_checkouts_id(current_organiser.checkouts))
		else
			@activities = Activity.update_session(params, parse_tempo)
			@cart_activities = Activity.get_my_activities_session(parse_tempo)
		end
			
    @show_my_activities = Activity.show_update(params)
    @activities_categories = ActivitiesCategory.all

    gon.city_activities = @activities

    session[:city] = City.find(params[:city_id])
    gon.city = City.find(params[:city_id])

    respond_to do |format|
      format.html
      format.js
    end
    
  end

  def index_not_current_city
    @city = params[:city][:id]
    redirect_to city_activities_path(params[:city][:id])
  end
  

  def show
		if user_signed_in?
			@cart_activities = Activity.get_my_activities(Checkout.get_checkouts_id(current_organiser.checkouts))
		else
			@cart_activities = Activity.get_my_activities_session(parse_tempo)
		end

    respond_to do |format|
      format.html
      format.js
    end
  end

	def import
    Activity.import(params[:activity][:file], params[:activity][:city_id])
    redirect_to city_activities_path(params[:city_id]), flash: {info: "Activities Added"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.fetch(:activity, {}).permit(:name,:address,:price,:description,:picture, :latitude, :longitude, :image)
    end

		def check_organiser
			if !current_organiser?
				flash[:info] = "Choose your city"
				redirect_to cities_path
			end
		end
end
