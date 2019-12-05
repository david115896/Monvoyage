class Organizer < ApplicationRecord

	belongs_to :user
	belongs_to :ticket

	def self.list_cookie(activities_array)
		list_activities = Array.new
		activities_array.each do |activity_id|
			list_activities << Ticket.find(activity_id: activity_id).first
		end
		return list_activities
	end

	def self.list_organizer(current_user)
		list_tickets = Array.new
		list_tickets_organizer = Organizer.where(user_id: current_user.id)
		list_tickets_organizer.each do |organize|
			list_tickets << Ticket.find(organize.ticket.id)
		end
		return list_tickets
	end
end
