class City < ApplicationRecord
  belongs_to :country

  has_many :activities
  
  validates :name, presence: true, uniqueness: true, format: {with: /\A[a-zA-Z0-9\s\.\,\(\)\-\'\_\&\*\[\]\|]+\z/}, length: {in: 2..100}
	validates :address, presence: true, format: {with: /\A[a-zA-Z0-9\s\.\,\(\)\-\'\_\&\*\[\]\|]+\z/}, length: {in: 2..100}
	validates :description, presence: true, format: {with: /\A[a-zA-Z0-9\s\.\n\"\,\(\)\-\'\_\&\*\[\]\|\\\’\>\<]+\z/}, length: {in: 20..10000}
  validates :climat, format: {with: /\A[a-zA-Z0-9\s\.\n\"\,\(\)\-\'\_\&\*\[\]\|\\\’]+\z/}, length: {in: 5..10000}
  validates :timezone, length: {in: 3..30}
	validates :traditions, length: {in: 5..10000}
  validates :picture, presence: true

end
