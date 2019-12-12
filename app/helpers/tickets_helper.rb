module TicketsHelper
	
		def set_tickets_id(checkouts)
			if user_signed_in?
			else
				tickets = []
				hash = JSON.parse cookies[:tempo_organiser]
				for checkout in hash["checkouts"] do
					tickets << Ticket.find(checkout["ticket_id"])
				end
				return tickets
			end
		end

		def set_ticket(checkout)
			if user_signed_in?
			else
				return Ticket.find(checkout["ticket_id"])
			end
		end

end
