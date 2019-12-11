module OrganisersHelper
	
	def current_duration
		return	Organiser.find(cookies[:organiser_id]).duration
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
