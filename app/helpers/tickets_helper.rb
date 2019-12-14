module TicketsHelper
	
		def get_tickets_id(checkouts)
			if user_signed_in?
			else
				tickets_id = []
				hash = JSON.parse cookies[:tempo_organiser]
				hash["checkouts"].each do |rank, checkout|
					tickets_id << Ticket.find(checkout["ticket_id"])
				end
				return tickets_id
			end
		end

		def get_ticket(checkout)
			if user_signed_in?
			else
				return Ticket.find(checkout.values.first["ticket_id"])
			end
		end

		# def get_tickets

end
