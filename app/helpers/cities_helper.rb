module CitiesHelper
	def current_city_id
		if user_signed_in?
			return Organiser.find(cookies[:organiser_id]).city_id
		else
			hash = JSON.parse cookies[:tempo_organiser]	
			city_id = hash["city_id"]
		end
	end
end
