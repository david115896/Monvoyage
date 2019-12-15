module OrganisersHelper
	
	def first_organiser
		return Organiser.first
	end

	def current_organiser
		begin
		organiser = Organiser.find(cookies[:organiser_id])
		rescue
		organiser = nil
		end
	return organiser
	end

	def current_organiser?
		check_cookies
		if (user_signed_in? && cookies[:organiser_id] != nil) || (!user_signed_in? && cookies[:tempo_organiser] != nil)
			return true
		else
			return false
		end
	end

	def current_city
		if user_signed_in?
			if cookies[:organiser_id] != nil
				begin
				city = Organiser.find(cookies[:organiser_id]).city
				rescue
				city = nil
				end
			end
		else
			if cookies[:tempo_organiser] != nil
				hash = JSON.parse cookies[:tempo_organiser]
				begin
				city = City.find(hash["city_id"])
				rescue
				city = nil
				end
			end
		end
		return city
	end

	def current_duration
		if user_signed_in?
			return	Organiser.find(cookies[:organiser_id]).duration
		else
			hash = JSON.parse cookies[:tempo_organiser]
			return hash["duration"]
		end
	end

	def check_cookies
		if current_organiser == nil || current_city == nil
			cookies.delete :organiser_id
		end

		if  current_city == nil
			cookies.delete :tempo_organiser
		end
	end

	def get_tempo_city
		if cookies[:tempo_organiser] != nil
			hash = JSON.parse cookies[:tempo_organiser]
			begin
			city = City.find(hash["city_id"])
			rescue
			city = nil
			end
			return city
		else
			return nil
		end
	end

	def reset_cookies
		cookies.delete :tempo_organiser
		cookies.delete :organiser_id
		session.delete :current_day
	end


	def delete_cookies
		if user_signed_in?
			cookies.delete :organiser_id
		else
			cookies.delete :tempo_organiser
		end
	end
	
	def set_minutes(minutes)
		if minutes == 0 
			return "00"
		else
			return minutes.to_s
		end
	end

	def duration_options
		options_array = []
		(1..10).each do |i|
				options_array << [i.to_s, i]
		end
	return  options_for_select(options_array, current_duration)
	end

	def day_options
		options_array = []
		(1..current_duration).each do |i|
			options_array << [i.to_s, i]
		end
		return options_for_select(options_array, session[:current_day])
	end
			
	def ticket_options(checkout)
		return Ticket.where(activity_id: checkout.ticket.activity.id)
	end

	def last_index
			return Checkout.where(organiser_id: cookies[:organiser_id], day: session[:current_day]).order(:index).last.index
	end

	def parse_tempo
		return JSON.parse cookies[:tempo_organiser]	
	end

end
