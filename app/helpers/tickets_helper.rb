module TicketsHelper
	def get_ticket_session(checkout)
			return Ticket.find(checkout.values.first["ticket_id"])
	end
end
