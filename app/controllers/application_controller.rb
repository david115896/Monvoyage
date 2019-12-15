class ApplicationController < ActionController::Base

    def configure_devise_parameters
        devise_parameter_sanitizer.permit(:sign_up) {|u| u.permit(:first_name, :last_name, :is_alive, :email, :password, :password_confirmation)}
        devise_parameter_sanitizer.permit(:account_update) {|u| u.permit(:first_name, :last_name, :address, :is_alive, :email, :password, :password_confirmation, :current_password)}
    end

	include CitiesHelper
	include CheckoutsHelper
	include OrganisersHelper
	include ActivitiesHelper
	include TicketsHelper

   # def after_sign_in_path_for(resource_or_scope)
	 				
   #      if get_tempo_city != nil 
   #          organiser = Organiser.save_cookies_in_table(current_user.id, get_tempo_city, get_tickets_id_session)
   #          cookies.delete(:tempo_organiser)
						# cookies.permanent[:organiser_id] = organiser.id
   #      end
				# flash[:success] = "A new organiser is create !"
   #      edit_organiser_path(organiser.id)
   #  end

   #  def after_sign_up_path_for(resource_or_scope)
   #      if get_tempo_city != nil
   #          organiser = Organiser.save_cookies_in_table(current_user.id, get_tempo_city, get_tickets_id_session)
   #          cookies.delete(:tempo_organiser)
						# cookies.permanent[:organiser_id] = organiser.id
   #      end
				# flash[:success] = "A new organiser is create !"
   #      edit_organiser_path(organiser.id)
   #  end
        

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
