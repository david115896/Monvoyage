class Organiser < ApplicationRecord

    belongs_to :user
    belongs_to :ticket
    
    def self.list_cookie(activities_array)
		list_activities = Array.new
		activities_array.each do |activity_id|
			list_activities << Activity.find(activity_id)
		end
		return list_activities
	end

	def self.list_organiser(current_user)
		list_tickets = Array.new
		list_tickets_organiser = Organiser.where(user_id: current_user.id)
		list_tickets_organiser.each do |organize|
			list_tickets << Ticket.find(organize.ticket.id)
		end
		return list_tickets
	end
end
