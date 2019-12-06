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
		list_tickets_organiser.each do |organize|
			list_tickets << Ticket.find(organize.ticket.id)
		end
		return list_tickets
	end
	
	def self.f_tickets(tickets)

		tickets 
		for ticket in tickets
			checkout.create(organiser: self.id, ticket: ticket.id)
		end
	end

	
end
