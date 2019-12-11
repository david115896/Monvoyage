class Checkout < ApplicationRecord

    belongs_to :organiser
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

	def self.amount(checkouts)
		amount = 0
		for checkout in checkouts do
			amount += checkout.ticket.price
		end
		return amount
	end

	def self.activities(checkouts)
		checkout_user_activities_array =Array.new
		checkouts.each do |checkout|
			checkout_user_activities_array << checkout.activity
		end
		return checkout_user_activities_array
	end

	def self.selected_activities(organiser_id)
		selected_activities_hash = Hash.new
		organiser = Organiser.find(organiser_id)
		organiser.duration.times do |index|
			selected_activities_hash["day#{index}"] = Array.new
			Checkout.where(organiser_id: organiser_id, day: (index+1)).each do |checkout|
				selected_activities_hash["day#{index}"] << checkout.ticket.activity
			end
		end
		return selected_activities_hash
	end

end
