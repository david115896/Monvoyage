class Organiser < ApplicationRecord

	belongs_to :user
	belongs_to :city

	has_many :checkouts
	has_many :tickets, through: :checkouts
    
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
end
