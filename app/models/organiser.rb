class Organiser < ApplicationRecord

	belongs_to :user
	belongs_to :city

	has_many :checkouts
	has_many :tickets, through: :checkouts
    
	
	def day_update(params, current_day)
		if current_day == nil
			return 1
		elsif params[:commit] == "change"
			return 1
		elsif params[:day] 
			return params[:day].to_i
		else
			return current_day
		end
	end

	def self.update(params, current_organiser_id)
		if params[:commit] == "change"
			return current_organiser_id
		else
			return params[:id]
		end
	end 

	def self.save_cookies_in_table(current_user_id, city_id, tickets_id)
		organiser = Organiser.create(user_id: current_user_id, city_id: city_id, duration: 1)
		tickets_id.each do |ticket_id|
			Checkout.create(organiser_id: organiser.id, ticket_id: ticket_id, selected: false, paid: false)
		end
		return organiser
	end


	def reset_checkouts
		checkouts = Checkout.where(organiser_id: self.id, paid: false)
		for checkout in  checkouts do
			checkout.selected = false	
			checkout.index = nil
			checkout.save
		end
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
