class SoldTicket < ApplicationRecord
    belongs_to :ticket
    belongs_to :order

		def self.multi_save(order, organiser_id)
			checkouts = Checkout.where(organiser_id: organiser_id)
			for checkout in checkouts
				checkout.paid = true
				SoldTicket.create(order: order, ticket: checkout.ticket)
				checkout.ticket.paid = true
			end
		end
end
