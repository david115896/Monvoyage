class Cart < ApplicationRecord

	belongs_to :user
	belongs_to :activity

	def self.list_activities_user(current_user, city_id)
		activities_array = Array.new
		@carts = Cart.where(city_id: city_id, user_id: current_user.id)
		@carts.each do |cart|
			activities_array << cart.activity
		end
		return 	activities_array
	end

end
