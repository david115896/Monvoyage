class OrganizersController < ApplicationController
  before_action :set_organizer, only: [:show, :edit, :update, :destroy]

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
		@organizer = Organizer.new
	end


	def create                                                                       	
		@organizer = Organizer.new(organizer_params)                                                  
		respond_to do |format|
			if @organizer.save
				format.html { redirect_to @organizer, notice: 'Organizer was successfully created.' }
				format.json { render :show, status: :created, location: @organizer }
			else
				format.html { render :new }
				format.json { render json: @organizer.errors, status: :unprocessable_entity }
			end
		end
	end

	def edit
		@organizer = Organizer.all.sample
	end

  def update
    respond_to do |format|
      if @organizer.update(organizer_params)
        format.html { redirect_to @organizer, notice: 'organizer was successfully updated.' }
        format.json { render :show, status: :ok, location: @organizer }
      else
        format.html { render :edit }
        format.json { render json: @organizer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @organizer.destroy
    respond_to do |format|
      format.html { redirect_to organizers_url, notice: 'organizer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
	
    # Use callbacks to share common setup or constraints between actions.
    def set_organizer
      @organizer = Organizer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organizer_params
      params.fetch(:organizer, {})
    end
end
