class Activity < ApplicationRecord
	
	require 'csv'

  belongs_to :activities_category

	has_many :carts
  has_many :users, through: :carts
  has_many :sold_items
  has_many :tickets

	def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
        Activity.create! row.to_hash
    end
  end
		
end
