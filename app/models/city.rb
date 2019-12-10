class City < ApplicationRecord
  belongs_to :country

  has_many :activities
  
  geocoded_by :address
	after_validation :geocode

end
