class SoldTicket < ApplicationRecord
    belongs_to :ticket
    belongs_to :order
end
