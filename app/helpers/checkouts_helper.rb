module CheckoutsHelper

	def first_checkout
		return Checkout.first
	end

	def set_index(checkout)
		if user_signed_in?
			checkouts = Checkout.where(organiser_id: checkout.organiser_id, day: session[:current_day]).order(:index)
			if	checkouts.size == 0
				return 1
			else
				return (checkouts.last.index.to_i + 1)
			end
		end
	end

	def swap_down(checkout)
		if user_signed_in?

			checkout_to_swap = Checkout.find_by(organiser_id: checkout.organiser_id, index: (checkout.index.to_i - 1), day: session[:current_day])
			tmp = checkout_to_swap.index
			checkout_to_swap.index = checkout.index
			checkout.index = tmp
			checkout_to_swap.save

		else

			hash = JSON.parse cookies[:tempo_organiser]
			hash["checkouts"].each do |rank, checkout_to_s|
				if get_index(rank => checkout_to_s) == get_index(checkout) - 1 
					tmp = get_index(rank => checkout_to_s) 
					hash["checkouts"][rank]["index"] = get_index(checkout)
					hash["checkouts"][checkout.keys.first]["index"] = tmp
				end
			end
			cookies[:tempo_organiser] = JSON.generate hash
		end
	end

	def swap_up(checkout)
		if user_signed_in?

			checkout_to_swap = Checkout.find_by(organiser_id: checkout.organiser_id, index: (checkout.index.to_i + 1), day: session[:current_day])
			tmp = checkout_to_swap.index
			checkout_to_swap.index = checkout.index
			checkout.index = tmp
			checkout_to_swap.save

		else

			hash = JSON.parse cookies[:tempo_organiser]
			hash["checkouts"].each do |rank, checkout_to_s|
				if get_index(rank => checkout_to_s) == get_index(checkout) + 1 
					tmp = get_index(rank => checkout_to_s) 
					hash["checkouts"][rank]["index"] = get_index(checkout)
					hash["checkouts"][checkout.keys.first]["index"] = tmp
				end
			end
			cookies[:tempo_organiser] = JSON.generate hash

		end
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

	
	def set_unselected_checkouts(checkouts)
		if user_signed_in?
		else
			unselected_checkouts = []
			checkouts.each do |rank, checkout|
				if !checkout["selected"]
					unselected_checkouts << {rank => checkout}
				end
			end
		end
		return unselected_checkouts
	end

	def set_selected_checkouts(checkouts)
		if user_signed_in?
		else
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
	end

	def set_checkouts
		hash = JSON.parse cookies[:tempo_organiser]
		return hash["checkouts"]
	end

	def set_rank
		hash = JSON.parse cookies[:tempo_organiser]
		if hash["checkouts"].keys.size > 0 
			return (hash["checkouts"].keys.last.to_i + 1).to_s
		else
			return 0
		end
	end

	def get_day(checkout)
	return	checkout.values.first["day"]
	end

	def get_index(checkout)
		return checkout.values.first["index"]
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

end
