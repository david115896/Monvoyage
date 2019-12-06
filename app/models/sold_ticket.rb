class SoldTicket < ApplicationRecord
    belongs_to :ticket
    belongs_to :order

		def multi_save(order_id)
			checkouts = Checkout.where(organiser_id: session[:organiser_id])
			for checkout in checkouts
				checkout.paid = true
				SoldItem.create(order_id: order_id, ticket_id: checkout.ticket.id)
			end
		end
end
