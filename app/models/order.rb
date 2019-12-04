class Order < ApplicationRecord
    has_many :Tickets
    has_many :Orders
    has_many :activities, through :tickets
    has_many :Cities, though :Activities
    belongs_to User
end
