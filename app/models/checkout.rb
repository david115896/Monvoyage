class Checkout < ApplicationRecord


    belongs_to :organiser
    belongs_to :ticket


	def self.update(checkout, params, current_day)

		checkout = Checkout.find(params[:id])

			if params[:commit] == "up"
				Checkout.swap_up(checkout, current_day)	
			elsif params[:commit] == "down"
				Checkout.swap_down(checkout, current_day)	
			elsif params[:commit] == "change"
				checkout = Checkout.find(params[:ticket][:checkout_id])
				ticket = Ticket.find(params[:ticket][:id])
				checkout.ticket_id = ticket.id	
			elsif params[:commit] == "Select this ticket"
				checkout.selected = true
				checkout.day = current_day
				checkout.index = checkout.set_index(current_day)
				checkout.ticket_id = params[:ticket][:id]
			elsif params[:commit] == "unselect"
				Checkout.update_index_after_unselect(checkout)
				checkout.selected = false
				checkout.day = nil
				checkout.index = nil
			end


			checkout.save
			
	end

	def self.get_selected_checkouts(current_organiser_id)	
		return Checkout.where(organiser_id: current_organiser_id, selected: true).order(:index)
	end

	def self.get_unselected_checkouts(current_organiser_id)	
		return Checkout.where(organiser_id: current_organiser_id, selected: false).order(:index)
	end

	def self.get_checkouts_id(checkouts)
		checkouts_id = []
		checkouts.each do |checkout|
						checkouts_id << checkout.id
		end 
		return checkouts_id
	end

	def set_index(current_day)

			checkouts = Checkout.where(organiser_id: self.organiser_id, day: current_day).order(:index)
			if	checkouts.size == 0
				return 1
			else
				return (checkouts.last.index.to_i + 1)
			end
	end

	def self.swap_down(checkout, current_day)

			checkout_to_swap = Checkout.find_by(organiser_id: checkout.organiser_id, index: (checkout.index.to_i - 1), day: current_day)
			tmp = checkout_to_swap.index
			checkout_to_swap.index = checkout.index
			checkout.index = tmp
			checkout_to_swap.save

	end

	def self.swap_up(checkout, current_day)

			checkout_to_swap = Checkout.find_by(organiser_id: checkout.organiser_id, index: (checkout.index.to_i + 1), day: current_day)
			tmp = checkout_to_swap.index
			checkout_to_swap.index = checkout.index
			checkout.index = tmp
			checkout_to_swap.save

	end

	def self.amount(checkouts)
		amount = 0
		for checkout in checkouts do
			amount += checkout.ticket.price
		end
		return amount
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

	def self.activities(checkouts)
		checkout_user_activities_array =Array.new
		checkouts.each do |checkout|
			checkout_user_activities_array << checkout.activity
		end
		return checkout_user_activities_array
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

	def update_checkout(index)
		if params[:commit] == "Select this ticket"
			hash = JSON.parse cookies[:tempo_organiser]
			checkout = hash["checkouts"][index]  
			checkout["selected"] = true
			cookies[:tempo_organiser] = JSON.generate hash
		else
			hash = JSON.parse cookies[:tempo_organiser]
			checkout = hash["checkouts"][index]  
			checkout["selected"] = false
			cookies[:tempo_organiser] = JSON.generate hash
		end
	end

end
