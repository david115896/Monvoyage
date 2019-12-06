class Checkout < ApplicationRecord
    belongs_to :organiser
    belongs_to :ticket


    def self.add_tickets(organiser_tickets_user, current_user)
        organiser_tickets_user.each do |ticket|
            Checkout.create(ticket_id: ticket.id, user_id: current_user.id)
        end
    end


	def self.list_checkout(current_user, id)
		list_tickets = Array.new
		list_tickets_checkout = Checkout.where(organiser_id: id)
		list_tickets_checkout.each do |organize|
			list_tickets << Ticket.find(organize.ticket.id)
		end
		return list_tickets
	end

	def self.amount(checkouts)
	amount = 0
		for checkout in checkouts do
			amount += checkout.ticket.price
			puts amount
		end
		return amount
	end
end
