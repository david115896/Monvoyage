class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
	before_action :check_organiser, only: [:index]

  def index

    @show_my_activities = Activity.show_update(params)
		@activities = Activity.update(params, get_checkouts_id(current_organiser.checkouts))
    @activities_categories = ActivitiesCategory.all
		@cart_activities = Activity.get_my_activities(get_checkouts_id(current_organiser.checkouts))

    gon.city_activities = @activities
    gon.city = City.find(params[:city_id])
    respond_to do |format|
      format.html
      format.js
    end
    
  end

  def show
    @cart_activities = Activity.get_my_activities(get_checkouts_id(current_organiser.checkouts))

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
