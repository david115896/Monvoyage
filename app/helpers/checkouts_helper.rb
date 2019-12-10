module CheckoutsHelper
	def set_index(checkout)
		if user_signed_in?
			checkouts = Checkouts.where(organiser_id: checkout.organiser_id).order(:index)
			if	checkouts == nil
				return 0
			else
				return checkouts.last.order + 1
			end
		end
	end

	def swap_up(checkout)
		if user_signed_in?
			checkout_to_swap = Checkout.find_by(oganiser_id: checkout.organiser_id, index: checkout.index - 1)
			tmp = checkout_to_swap.index
			checkout_to_swap.index = checkout.index
			checkout.index = tmp
		end
	end

	def swap_down(checkout)
		if user_signed_in?
			checkout_to_swap = Checkout.find_by(oganiser_id: checkout.organiser_id, index: checkout.index + 1)
			tmp = checkout_to_swap.index
			checkout_to_swap.index = checkout.index
			checkout.index = tmp
		end
	end

end
