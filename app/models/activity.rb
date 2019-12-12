class Activity < ApplicationRecord
	
	belongs_to :activities_category
	belongs_to :city

	has_many :tickets

	geocoded_by :address
	after_validation :geocode, :if => lambda{ |obj| obj.address_changed? }	

	has_one_attached :picture


	
	def self.import(file, city_id)
    	CSV.foreach(file.path, headers: true) do |row|
			activities_hash = row.to_hash
			activities_hash[:city] = City.find_by(name: row[4])
			activities_hash[:activities_category] = ActivitiesCategory.where(name: row[5]).first
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

	def self.set_my_activities(current_user, organiser_id)
		list_activities = Array.new
		list_activities_checkout = Checkout.where(organiser_id: Organiser.find(organiser_id).id)
		list_activities_checkout.each do |checkout|
			list_activities << Activity.find(checkout.ticket.activity.id)
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
