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
	
end
