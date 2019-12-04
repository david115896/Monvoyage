class Organizer < ApplicationRecord

	
		has_many :tickets
    has_many :activites, through: :tickets
		
		belongs_to :user

end
