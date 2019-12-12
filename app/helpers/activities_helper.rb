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
				checkouts = hash[:checkouts]
				tickets = []
				for checkout in checkouts
					tikets << checkout[:ticket_id]
				end
				activities = Activities.where(ticket_id: tickets)
				binding.pry
			end
			return activities
		end
	
end
