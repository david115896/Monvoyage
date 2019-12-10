class SoldTicket < ApplicationRecord
    belongs_to :ticket
    belongs_to :order

		def self.multi_save(order, organiser_id)
			checkouts = Checkout.where(organiser_id: organiser_id)
			for checkout in checkouts
				checkout.paid = true
				checkout.save
				SoldTicket.create(order: order, ticket: checkout.ticket)
			end
		end
end
