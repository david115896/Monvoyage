class Ticket < ApplicationRecord
    belongs_to :activity

    has_many :organisers
    has_many :sold_tickets
    has_many :checkouts

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
					tickets_id << Ticket.find(checkout["ticket_id"])
				end
				return tickets_id
		end

end
