module ActivitiesHelper
	
		
	def get_selected_activities


		if user_signed_in?
			
			tickets_id = get_tickets_id(get_selected_checkouts)
			activities = Activity.joins(:tickets).where("tickets.id IN (?)", tickets_)
		else

			tickets = get_tickets_id(selected_checkouts)
			return Activity.joins(:tickets).where("tickets.id IN (?)", tickets)

		end
	end

	def get_activity_session(rank)
		hash = JSON.parse cookies[:tempo_organiser]
		ticket_id = hash["checkouts"][rank]["ticket_id"]
		ticket = Ticket.find(ticket_id)
		return ticket.activity
	end


end
