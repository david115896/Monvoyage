module ActivitiesHelper
	
	def get_activity_session(rank)
		hash = JSON.parse cookies[:tempo_organiser]
		ticket_id = hash["checkouts"][rank]["ticket_id"]
		ticket = Ticket.find(ticket_id)
		return ticket.activity
	end


end
