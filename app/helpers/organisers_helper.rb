module OrganisersHelper
	
	def current_duration
		return	Organiser.find(cookies[:organiser_id]).duration
	end


	def first_organiser_id
		return Organiser.first.id
	end

	def first_city_id
		return Organiser.first.city.id
	end

	def reset_cookies
		if user_signed_in?
			if cookies[:organiser_id] == nil || params[:commit] == "new_travel"
				cookies[:organiser_id] = first_organiser_id
			end
		else
			if params[:commit] == "new_travel"
				cookies[:tempo_organiser] = nil
			end
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
		(1..30).each do |i|
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

end
