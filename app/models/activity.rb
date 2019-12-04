class Activity < ApplicationRecord
	
		has_many :carts
    has_many :users, through: :carts
    has_many :sold_items
    belongs_to :city

    geocoded_by :adress
    after_validation :geocode
end
