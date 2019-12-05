class Order < ApplicationRecord
    has_many :tickets
    has_many :Orders
    has_many :activities, through: :tickets
    has_many :Cities, through: :activities
    has_many :sold_tickets
    belongs_to :user
end
