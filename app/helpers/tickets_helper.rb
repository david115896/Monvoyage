module TicketsHelper
	
		def get_tickets_id_session
				tickets_id = []
				hash = JSON.parse cookies[:tempo_organiser]
				hash["checkouts"].each do |rank, checkout|
					tickets_id << Ticket.find(checkout["ticket_id"])
				end
				return tickets_id
		end

		def get_ticket_session(checkout)
				return Ticket.find(checkout.values.first["ticket_id"])
		end

		# def get_tickets

end
