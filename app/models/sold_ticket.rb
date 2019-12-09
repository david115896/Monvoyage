class SoldTicket < ApplicationRecord
    belongs_to :ticket
    belongs_to :order

		def self.multi_save(order, current_user)
			checkouts = Checkout.where(user_id: current_user.id)
			for checkout in checkouts
				checkout.paid = true
				SoldTicket.create(order: order, ticket: checkout.ticket)
			end
		end
end
