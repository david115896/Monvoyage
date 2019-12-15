class Ticket < ApplicationRecord
    belongs_to :activity

    has_many :organisers
    has_many :sold_tickets
	has_many :checkouts
	

	validates :name, presence: true, uniqueness: true, format: {with: /\A[^*!@%\^]+\z/}, length: {in: 5..100}
	validates :description, format: {with: /\A[^*!@%\^]+\z/}, length: {in: 0..10000}, allow_blank: true
	validates :price, presence: true, :inclusion => 1..1000
	validates :category, presence: true, format: {with: /\A[a-zA-Z\s\/\&]+\z/}, length: {in: 5..30}
	validates :duration, presence: true, :inclusion => 1..1000

    def self.import(file)
    	CSV.foreach(file.path, headers: true) do |row|
            tickets_hash = row.to_hash
            tickets_hash[:duration] = (row[1].to_f)*60
			tickets_hash[:activity] = Activity.where(name: row[4]).first
			Ticket.create! tickets_hash
			end
		end
		
		
		def self.get_tickets_id_session(checkouts)
				tickets_id = []
				checkouts.each do |rank, checkout|
					tickets_id << Ticket.find(checkout["ticket_id"]).id
				end
				return tickets_id
		end

end
