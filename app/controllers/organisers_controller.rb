class OrganisersController < ApplicationController
  before_action :set_organiser, only: [:show, :edit, :update, :destroy]

  def index
    if user_signed_in?
      @cart_activities = Activity.list_cart(current_user)
      @organisers_tickets = Organiser.list_organiser(current_user)
      gon.organiser_activities = @cart_activities

    else
      if cookies[:activities] != nil
        @cart_activities = Activity.list_cookie(JSON.parse(cookies[:activities]))
        gon.organiser_activities = @cart_activities

      else
        @cart_activities = Array.new
      end

      if cookies[:organiser] != nil
        @organisers_tickets = Organiser.list_cookie(JSON.parse(cookies[:organiser]))
      else
        @organisers_tickets = Array.new
      end
    end  
  end


  def show
		@organiser = Organiser.find(cookies[:organiser_id])
		@tickets = @organiser.tickets
  end

  def new
    @organiser = Organiser.new
  end

	def create
		organiser = Organiser.new(user: current_user, city_id: params[:organiser][:city_id])

		if organiser.save
			cookies.permanent[:organiser_id] = organiser.id
			redirect_to city_activities_path(params[:organiser][:city_id])
		end
	end

  def edit

		if params[:commit] == "change"
			cookies[:organiser_id] = params[:id]
		end

		@unselected_checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: false)
		@selected_checkouts = Checkout.where(organiser_id: cookies[:organiser_id], selected: true)
    gon.organiser_activities = @cart_activities
  end

  def update
    respond_to do |format|
      if @organiser.update(organiser_params)
        format.html { redirect_to @organiser, notice: 'Organiser was successfully updated.' }
        format.json { render :show, status: :ok, location: @organiser }
      else
        format.html { render :edit }
        format.json { render json: @organiser.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @organiser.destroy
    respond_to do |format|
      format.html { redirect_to organisers_url, flash: { success: 'Activity was successfully removed from planning.' }}
      format.json { head :no_content }
    end
  end

  def destroy_ticket_cookie
    new_array = Array.new
    array = JSON.parse(cookies[:organiser])
    array.each do |ticket_id|
      if ticket_id != params[:ticket_id].to_i
        new_array << ticket_id
      end
    end
    cookies[:organiser] = JSON.generate(new_array)
    redirect_to organisers_url, flash: { success: 'Activity was successfully removed from planning.' }
  end

  def validate_organiser
    if user_signed_in?
      @checkout = Checkout.add_tickets(Organiser.where(user_id: current_user.id), current_user)
      redirect_to checkouts_path
    else

    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organiser
      @organiser = Organiser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organiser_params
      params.fetch(:organiser, {})
    end
end
