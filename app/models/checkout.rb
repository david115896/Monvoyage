class Checkout < ApplicationRecord


    belongs_to :organiser
    belongs_to :ticket





	def self.amount(checkouts)
		amount = 0
		for checkout in checkouts do
			amount += checkout.ticket.price
		end
		return amount
	end

	def self.activities(checkouts)
		checkout_user_activities_array =Array.new
		checkouts.each do |checkout|
			checkout_user_activities_array << checkout.activity
		end
		return checkout_user_activities_array
	end

	def self.update_index_after_unselect(checkout)
		checkouts = Checkout.where("day = ? AND organiser_id = ? AND index > ?", checkout.day, checkout.organiser_id, checkout.index).order(:index)
		for checkout in checkouts
			checkout.index -= 1
			checkout.save
		end
	end

	def get_duration(next_step)
		begin 
			origin = self.ticket.activity.latitude.to_s + ',' + self.ticket.activity.longitude.to_s
			destination = next_step.ticket.activity.latitude.to_s + ',' + next_step.ticket.activity.longitude.to_s
			
			url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{origin}&destinations=#{destination}&key=#{ENV['MAP_KEY']}"
			response = HTTParty.get(url)

			duration = response["rows"].first["elements"].first["duration"]["value"]/60.0.round
		rescue
			duration = 0
		end	
		return duration

	end

	def self.get_duration_v(ticket, next_step)
		
		origin = ticket.activity.latitude.to_s + ',' + ticket.activity.longitude.to_s
		destination = next_step.activity.latitude.to_s + ',' + next_step.activity.longitude.to_s
		
		url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=#{origin}&destinations=#{destination}&key=#{ENV['MAP_KEY']}"
		response = HTTParty.get(url)

		duration = response["rows"].first["elements"].first["duration"]["value"]/60.0.round
		return duration



	end

	def self.selected_activities(organiser_id)
		selected_activities_hash = Hash.new
		organiser = Organiser.find(organiser_id)
		organiser.duration.times do |index|
			selected_activities_hash["day#{index}"] = Array.new
			Checkout.where(organiser_id: organiser_id, day: (index+1)).each do |checkout|
				selected_activities_hash["day#{index}"] << checkout.ticket.activity
			end
		end
		
		return selected_activities_hash
	end

end
