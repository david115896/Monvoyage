class ActivitiesCategory < ApplicationRecord
    has_many :activities

    validates :name, presence: true, uniqueness: true, format: {with: /\A[a-zA-Z\&\/\s]+\z/}, length: {in: 5..30}

end
