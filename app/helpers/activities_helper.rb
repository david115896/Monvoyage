module ActivitiesHelper
	
		# def set_my_activities
		# 	if user_signed_in?

		# 		checkouts = Checkout.where(organiser_id: cookies[:organiser_id])
		# 		activities = []
		# 		for checkout in checkouts
		# 			activities << checkout.ticket.activity
		# 		end
		# 	else

		# 		hash = JSON.parse cookies[:tempo_organiser]
		# 		checkouts = hash["checkouts"]
		# 		tickets = []
		# 		if checkouts != nil
		# 			checkouts.each do |rank, checkout|
		# 				tickets << checkout["ticket_id"]
		# 			end
		# 		end
		# 	end
		# 	return activities

		# end
	
	
		def get_my_activities
			if user_signed_in?
				
				checkouts_id = get_checkouts_id(current_organiser.checkouts)
				Activity.joins(:tickets).joins(:checkouts).where("checkouts.id IN (?)", checkouts_id)

			else

				hash = JSON.parse cookies[:tempo_organiser]
				checkouts = hash["checkouts"]
				tickets = []
				if checkouts != nil
					checkouts.each do |rank, checkout|
						tickets << checkout["ticket_id"]
					end
				end
			end
			return tickets

		end
		
	def get_selected_activities


		if user_signed_in?
			
			tickets_id = get_tickets_id(get_selected_checkouts)
			activities = Activity.joins(:tickets).where("tickets.id IN (?)", tickets_)
		else

			tickets = get_tickets_id(selected_checkouts)
			return Activity.joins(:tickets).where("tickets.id IN (?)", tickets)

		end
	end


end
