class UsersController < ApplicationController

	before_action :set_user, only: [:show, :edit, :update, :destroy]

	def show
		@user = User.find(params[:id])
	end

	def edit
		@user = User.all.sample
	end

	def update
		if @user.update(user_params)
      redirect_to @user, flash: {success: " Your account is up-to-date !" }
    else
      render :edit
    end
	end

	def destroy
    @user.destroy
    redirect_to users_url, flash: {success: "Your account has been deleted !" } 
  end

	private
    # Use callbacks to share common setup or constraints between actions.
  def set_user
    begin
      @user = User.find(params[:id])
    rescue
      redirect_to new_user_session, flash: {danger: "This user doesn't exist !" }
    end
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.fetch(:user, {})
  end

end
