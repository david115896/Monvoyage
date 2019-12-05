class Ticket < ApplicationRecord
belongs_to :activity
has_many :organizers
has_many :sold_tickets
end
