class Organizer < ApplicationRecord

	belongs_to :user

	has_many :tickets
	has_many :activites, through: :tickets
		
end
