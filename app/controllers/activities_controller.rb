class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
	before_action :check_organiser, only: [:index]

  def index
    @show_my_activities = false
	if user_signed_in?
		if params[:commit] == "Go"
			@activities = Activity.where(city_id: params[:city][:id], activities_category: ActivitiesCategory.find_by(name: "Landmarks"))	
		elsif params[:commit] == "Search"
			selected_category_id = params[:city][:activities_category_id]
			@activities = Activity.where(city_id: params[:city_id], activities_category_id: selected_category_id)
    elsif params[:commit] == "my_activities"
      @show_my_activities = true
			@activities = set_my_activities
		else
			@activities = Activity.where(city_id: params[:city_id], activities_category: ActivitiesCategory.find_by(name: "Landmarks"))	
		end
			@cart_activities = Activity.set_my_activities(current_user, cookies[:organiser_id])
	else
		if params[:commit] == "Go"
			@activities = Activity.where(city_id: params[:city][:id], activities_category: ActivitiesCategory.find_by(name: "Landmarks"))	
		elsif params[:commit] == "Search"
			selected_category_id = params[:city][:activities_category_id]
			@activities = Activity.where(city_id: params[:city_id], activities_category_id: selected_category_id)
		elsif params[:commit] == "my_activities"
			@activities = set_my_activities
		else
			@activities = Activity.where(city_id: params[:city_id], activities_category: ActivitiesCategory.find_by(name: "Landmarks"))	
		end
	end
			
		
		# if cookies[:activities] == nil
      # @cart_activities = Array.new
		# elsif
      # @cart_activities = cookies[:activities]
		# end
		
    @activities_categories = ActivitiesCategory.all

    gon.city_activities = @activities
    gon.city = City.find(params[:city_id])
    respond_to do |format|
      format.html
      format.js
    end
    
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: 'Activity was successfully created.' }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: 'Activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_url, notice: 'Activity was successfully destroyed.' }
      format.json { head :no_content }
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
			if user_signed_in? && cookies[:organiser_id] == first_organiser_id
				flash[:info] = "Choose your city"
				redirect_to cities_path
			end
		end
				
				

end
