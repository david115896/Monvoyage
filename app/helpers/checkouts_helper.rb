module CheckoutsHelper

	def first_checkout
		return Checkout.first
	end

	def checkout_to_destroy(activity)
		return Checkout.find_by(ticket: Ticket.where(activity: activity), organiser_id: cookies[:organiser_id]).id
	end

	def checkout_destroy_session(rank)
		hash = JSON.parse cookies[:tempo_organiser]
		hash["checkouts"].delete(rank)
		cookies[:tempo_organiser] = JSON.generate hash	
	end

	def set_rank
		hash = JSON.parse cookies[:tempo_organiser]
		if hash["checkouts"].keys.size > 0 
			return (hash["checkouts"].keys.last.to_i + 1).to_s
		else
			return 0
		end
	end

	def get_day_session(checkout)
		return	checkout.values.first["day"]
	end

	def get_checkouts_of_this_day(day)
		if user_signed_in?
			return Checkouts.where(organiser_id: current_organiser.id, selected: true, day: day)		
		end
	end

end
