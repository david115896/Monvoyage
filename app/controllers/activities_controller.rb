class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]


  def index
		if params[:commit] == "Search"
			selected_category_id = params[:city][:activities_category_id]
			@activities = Activity.where(city_id: params[:city_id], activities_category_id: selected_category_id)
		else
			@activities = Activity.where(city_id: params[:city_id], activities_category: ActivitiesCategory.find_by(name: "Landmarks"))	
		end
    @activities_categories = ActivitiesCategory.all
    if user_signed_in?
      @cart_actitivies = Cart.list_activities_user(current_user, params[:city_id])
    elsif cookies[:activities] == nil
      @cart_actitivies = Array.new
    else
      @cart_actitivies = cookies[:activities]
    end

    gon.city_activities = @activities
    gon.city = City.find(params[:city_id])

  end

  def show
    respond_to do |format|
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
      params.fetch(:activity, {}).permit(:name,:address,:price,:description,:picture)
    end
end
