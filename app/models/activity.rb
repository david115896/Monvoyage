class Activity < ApplicationRecord
	
		require 'csv'
		has_many :carts
    has_many :users, through: :carts
    has_many :sold_items

		def self.import(file)
        CSV.foreach(file.path, headers: true) do |row|
            Activity.create! row.to_hash
        end
    end
		
end
