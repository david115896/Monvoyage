class ApplicationController < ActionController::Base

    def configure_devise_parameters
        devise_parameter_sanitizer.permit(:sign_up) {|u| u.permit(:first_name, :last_name, :is_alive, :email, :password, :password_confirmation)}
        devise_parameter_sanitizer.permit(:account_update) {|u| u.permit(:first_name, :last_name, :address, :is_alive, :email, :password, :password_confirmation, :current_password)}
    end

	include CitiesHelper
	include CheckoutsHelper
	include OrganisersHelper

   # def after_sign_in_path_for(resource_or_scope)
   #      if cookies[:organiser] != nil
   #          Organiser.put_cookies_in_table(current_user, JSON.parse(cookies[:organiser]))
   #          cookies.delete(:organiser)
   #      end
   #      static_index_path
   #  end

    # def after_sign_up_path_for(resource_or_scope)
    #     if cookies[:organiser] != nil
    #         Organiser.put_cookies_in_table(current_user, JSON.parse(cookies[:organiser]))
    #         cookies.delete(:organiser)
    #     end
    #     static_index_path
    # end
        

    def after_sign_out_path_for(resource_or_scope)
       static_index_path
    end

    def authenticate_user
        unless user_signed_in?
            redirect_to new_user_session_path, flash: {danger: "Please to log in!"}
        end
    end

    def authenticate_admin
        if user_signed_in?
            unless current_user.is_admin?
                redirect_to activities_path, flash: {danger: "Access restricted to admin!"}
            end
        else 
            redirect_to activities_path, flash: {danger: "Access restricted to admin!"}
        end 
    end


end
