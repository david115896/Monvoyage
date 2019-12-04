class Activity < ApplicationRecord
		has_many :carts
    has_many :users, through: :carts
    has_many :sold_items
    has_many :tickets
    belongs_to :activities_category
end
