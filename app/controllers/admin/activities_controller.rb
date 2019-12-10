class Admin::ActivitiesController < ApplicationController
  before_action :authenticate_admin
	before_action :set_activity, only: [:show, :edit, :update, :destroy]
	
	def index
    @activities = Activity.all
    @city = City.all.sample
    @cities = City.all

	end

	def show
		
	end

	def new
		@activity = Activity.new
		@cities = City.all
		@activities_categories = ActivitiesCategory.all
	end

	def create
		@activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to admin_activities_path, flash: {success: 'Activity was successfully created.'} }
      else
        format.html { render :new }
      end
    end
	end

	def edit
		@cities = City.all
		@activities_categories = ActivitiesCategory.all
	end

	def update

		puts 'e' * 45
		puts @activity.name
		puts activity_params
		respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to admin_activities_path, flash: { success: 'Activity was successfully updated.'} }
      else
        format.html { render :edit }
      end
    end
	end

	def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to admin_activities_path,flash: { success: 'Activity was successfully destroyed.'} }
    end
  end

	private
  # Use callbacks to share common setup or constraints between actions.
  def set_activity
    @activity = Activity.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def activity_params
    params.fetch(:activity, {}).permit(:name, :address, :price, :description, :city_id, :activities_category_id)
  end

end
