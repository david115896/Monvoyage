class Checkout < ApplicationRecord
    belongs_to :user
    belongs_to :ticket


    def self.add_tickets(organiser_tickets_user, current_user)
        organiser_tickets_user.each do |ticket|
            Checkout.create(ticket_id: ticket.id, user_id: current_user.id)
        end
    end
end
