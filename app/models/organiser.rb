class Organiser < ApplicationRecord

	belongs_to :user
	belongs_to :city

	has_many :checkouts
	has_many :tickets, through: :checkouts
    
	
	def maj_day(params, current_day)
		
		if current_day == nil
			return 1
		end
			
		if params[:commit] == "change"
			return 1
		end

		if params[:day] 
			return params[:day].to_i
		end

	end

	def self.maj_organiser(params, current_organiser_id)
		if params[:commit] == "change"
			return current_organiser_id
		else
			return params[:id]
		end
	end 


	def reset_checkouts
		checkouts = Checkout.where(organiser_id: self.id, paid: false)
		for checkout in  checkouts do
			checkout.selected = false	
			checkout.index = nil
		end
	end

	def self.get_duration
		
		origin = "46.415710,-0.355860"
		destination = "46.381370,-0.388350"
		
		url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{origin}&destinations=#{destination}&key=#{ENV['MAP_KEY']}"
		response = HTTParty.get(url)

		duration = round(response["rows"].first["elements"].first["duration"]["value"]/60.0,0)

		return duration

	end
	
	def self.show_activities_or_itinerary(session_show_itinerary)
		if session_show_itinerary == nil
			show = false
		elsif session_show_itinerary == false
			show == true
		else
			show == false
		end

		return show

	end
end
