module TicketsHelper
	
		def set_tickets_id(checkouts)
			if user_signed_in?
			else
				tickets = []
				hash = JSON.parse cookies[:tempo_organiser]
				hash["checkouts"].each do |rank, checkout|
					tickets << Ticket.find(checkout["ticket_id"])
				end
				return tickets
			end
		end

		def get_ticket(checkout)
			if user_signed_in?
			else
				return Ticket.find(checkout.values.first["ticket_id"])
			end
		end

end
