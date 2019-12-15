class Country < ApplicationRecord
    has_many :cities

    validates :name, presence: true, uniqueness: true, format: {with: /\A[a-zA-Z0-9\s\.\,\(\)\-\'\_\&\*\[\]\|]+\z/}, length: {in: 5..100}
	validates :position, presence: true, format: {with: /\A[a-zA-Z0-9\s\.\,\(\)\-\'\_\&\*\[\]\|]+\z/}, length: {in: 5..100}

end