class Ticket < ApplicationRecord
    belongs_to :activity

    has_many :organisers
    has_many :sold_tickets
    has_many :checkouts

    def self.import(file)
    	CSV.foreach(file.path, headers: true) do |row|
            tickets_hash = row.to_hash
			tickets_hash[:activity] = Activity.where(name: row[5]).first
			Ticket.create! tickets_hash
		end
	end
end
