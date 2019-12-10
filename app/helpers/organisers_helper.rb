module OrganisersHelper
	
	def current_duration
		return	Organiser.find(cookies[:organiser_id]).duration
	end



	def options_duration
		options_array = []
		(1..30).each do |i|
				options_array << [i.to_s, i]
		end
	return  options_for_select(options_array, current_duration)
	end

	def options_days
		options_array = []
		(1..current_duration).each do |i|
			options_array << [i.to_s, i]
		end
		
		return options_for_select(options_array, session[:current_day])
	end
			

end
