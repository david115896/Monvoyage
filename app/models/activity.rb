class Activity < ApplicationRecord
	
	require 'csv'

  belongs_to :activities_category
	belongs_to :city

	has_many :carts
  has_many :users, through: :carts
  has_many :sold_items
  has_many :tickets

	geocoded_by :address
	after_validation :geocode
	
	def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
			activities_hash = row.to_hash
			activities_hash[:city] = City.find_by(name: activities_hash["city"])
			activities_hash[:activities_category] = ActivitiesCategory.find_by(name: activities_hash["activities_category"])
			Activity.create! activities_hash
    end
  end
		
end
