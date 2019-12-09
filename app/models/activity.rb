class Activity < ApplicationRecord
	
#	require 'csv'

	belongs_to :activities_category
	belongs_to :city

	has_many :carts
  	has_many :users, through: :carts
  	has_many :sold_items
  	has_many :tickets

	geocoded_by :address
	after_validation :geocode
	
	def self.import(file, city_id)
    	CSV.foreach(file.path, headers: true) do |row|
			activities_hash = row.to_hash
			#activities_hash[:city] = City.find(city_id)
			Activity.create! activities_hash
		end
	end
	
	def self.list_cookie(activities_array)
		list_activities = Array.new
		activities_array.each do |activity_id|
			list_activities << Activity.find(activity_id)
		end
		return list_activities
	end

	def self.list_cart(current_user)
		list_activities = Array.new
		list_activities_cart = Cart.where(user_id: current_user.id)
		list_activities_cart.each do |cart|
			list_activities << Activity.find(cart.activity.id)
		end
		return list_activities
	end

	def self.amount(cart_activities)
        amount = 0
        cart_activities.each do |activity|
            amount += activity.price
        end
        return amount
    end
end
