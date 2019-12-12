module ActivitiesHelper
	
		def set_my_activities
			if user_signed_in?
				checkouts = Checkout.where(organiser_id: cookies[:organiser_id])
				activities = []
				for checkout in checkouts
					activities << checkout.ticket.activity
				end
			else
				hash = JSON.parse cookies[:tempo_organiser]
				checkouts = hash["checkouts"]
				tickets = []
				if checkouts != nil
					for checkout in checkouts
						tickets << checkout["ticket_id"]
					end
				end
				activities = Activity.joins(:tickets).where("tickets.id IN (?)", tickets)
			end
			return activities
		end
	
		
	def set_selected_activities(selected_checkouts)
		if user_signed_in?
		else
			tickets = set_tickets_id(selected_checkouts)
			return Activity.joins(:tickets).where("tickets.id IN (?)", tickets)
		end
	end
end
