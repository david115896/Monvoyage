module CheckoutsHelper
	def set_index(checkout)
		if user_signed_in?
			checkouts = Checkout.where(organiser_id: checkout.organiser_id, day: session[:current_day]).order(:index)
			if	checkouts.size == 0
				return 1
			else
				return checkouts.last.index + 1
			end
		end
	end

	def swap_down(checkout)
		if user_signed_in?
			checkout_to_swap = Checkout.find_by(organiser_id: checkout.organiser_id, index: checkout.index - 1, day: session[:current_day])
			tmp = checkout_to_swap.index
			checkout_to_swap.index = checkout.index
			checkout.index = tmp
			checkout_to_swap.save
		end
	end

	def swap_up(checkout)
		if user_signed_in?
			checkout_to_swap = Checkout.find_by(organiser_id: checkout.organiser_id, index: checkout.index + 1, day: session[:current_day])
			tmp = checkout_to_swap.index
			checkout_to_swap.index = checkout.index
			checkout.index = tmp
			checkout_to_swap.save
		end
	end

end
