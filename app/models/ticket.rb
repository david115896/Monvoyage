class Ticket < ApplicationRecord
belongs_to :activity

has_many :organisers
has_many :sold_tickets
has_many :checkouts

end
