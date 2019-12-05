class Admin::UsersController < ApplicationController

	before_action :set_user, only: [:show, :edit, :update, :destroy]

	def index
		@users = User.all	
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save then
      redirect_to admin_users_path, flash: {success: " User is create !" }
    else
      render :new
    end

	end

	def edit
		@user = User.new
	end

	def update
		if @user.update(user_params) then
      redirect_to @user, flash: {success: " Your account is up-to-date !" }
    else
      render :edit
    end
	end

	def destroy
    @user.destroy
    redirect_to admin_users_url, flash: {success: "Your account has been deleted !" } 
	end

	private	
  def set_user
    begin
      @user = User.find(params[:id])
    rescue
      redirect_to new_user_session, flash: {danger: "This user doesn't exist !" }
    end
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.fetch(:user, {}).permit(:first_name, :last_name, :description, :adress, :password, :email, :is_admin)
  end


end
