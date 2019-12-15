module CheckoutsHelper

	def first_checkout
		return Checkout.first
	end

	def get_checkouts
			hash = JSON.parse cookies[:tempo_organiser]
			return hash["checkouts"]
	end

	def checkout_to_destroy(activity)
		if user_signed_in?

			return Checkout.find_by(ticket: Ticket.where(activity: activity), organiser_id: cookies[:organiser_id]).id

		else

			ticket_id = Ticket.joins(:activity).where("activity_id = ?", activity.id).first.id
			hash = JSON.parse cookies["tempo_organiser"]
			checkouts = hash["checkouts"]
			checkouts.each do |rank, checkout|
				if checkout["ticket_id"] == ticket_id
					return rank
				end
			end

		end
	end
	
	def checkout_destroy_session(rank)

		hash = JSON.parse cookies[:tempo_organiser]
		hash["checkouts"].delete(rank)
		cookies[:tempo_organiser] = JSON.generate hash	

	end

	def get_selected_checkouts_session

			selected_checkouts = []
			current_index =1
			while current_index <= checkouts.size 
				checkouts.each do |rank, checkout|
					if checkout["selected"] && get_index({rank => checkout}) == current_index
						selected_checkouts << {rank => checkout}
					end
				end
				current_index += 1
			end
			return selected_checkouts

	end
			
	def get_unselected_checkouts_session

		unselected_checkouts = []
		checkouts.each do |rank, checkout|
			if !checkout["selected"]
				unselected_checkouts << {rank => checkout}
			end
		end
	return unselected_checkouts

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

	def update_checkouts_after_unselect(rank)

		hash = JSON.parse cookies[:tempo_organiser]
		hash["checkouts"][rank]["selected"] = false
		hash["checkouts"][rank]["day"] = 0
		index = hash["checkouts"][rank]["index"]
		i = 0
		hash["checkouts"] do |rank, checkout|
			if checkout["index"] > index
				checkout["index"] -= 1
			end
		end
		cookies[:tempo_organiser] = JSON.generate hash

	end

	
	def get_checkouts_id(checkouts)

		checkouts_id = []
		checkouts.each do |checkout|
			checkouts_id << checkout.id
		end 

		return checkouts_id
	end

	def get_checkouts_of_this_day(day)
		if user_signed_in?
			return Checkouts.where(organiser_id: current_organiser.id, selected: true, day: day)		
		else
		end
	end

end
