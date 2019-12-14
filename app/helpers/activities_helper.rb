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


end
