class Organizer < ApplicationRecord

	belongs_to :user

	has_many :tickets
	has_many :activities, through: :tickets
		
end
