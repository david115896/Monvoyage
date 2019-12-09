class Organiser < ApplicationRecord

	belongs_to :user
	belongs_to :ticket
    
    def self.list_cookie(tickets_array)
		list_tickets = Array.new
		if tickets_array.kind_of?(Array)
			tickets_array.each do |ticket_id|
					list_tickets << Ticket.find(ticket_id)
			end
		else
			list_tickets << Ticket.find(tickets_array)
		end
		return list_tickets
	end

	def self.list_organiser(current_user)
		list_tickets = Array.new
		list_tickets_organiser = Organiser.where(user_id: current_user.id)
		list_tickets_organiser.each do |organise|
			list_tickets << organise.ticket
		end
		return list_tickets
	end
	
	def self.put_cookies_in_table(current_user, tickets_ids)
		tickets_ids.each do |ticket_id|
			Organiser.create(user_id: current_user, ticket_id: ticket_id)
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
