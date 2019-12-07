class Checkout < ApplicationRecord
    belongs_to :user
    belongs_to :ticket


	def self.add_tickets(current_user)
		Checkout.where(user_id: current_user.id).destroy_all
		list_organisers = Organiser.where(user_id: current_user.id)
        list_organisers.each do |organiser|
            Checkout.create(ticket_id: organiser.ticket.id, user_id: current_user.id)
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



	def self.amount(current_user)
		amount = 0
		checkouts = Checkout.where(user_id: current_user.id)
		for checkout in checkouts do
			amount += checkout.ticket.price
		end
		return amount
	end
end
