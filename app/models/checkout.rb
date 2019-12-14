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
			
			# if params[:commit] == "up"
			# 	hash = JSON.parse cookies[:tempo_organiser]
			# 	rank = params[:id]
			# 	checkout = hash["checkouts"][rank]
			# 	swap_up({rank => checkout})	
			# end

			# if params[:commit] == "down"
			# 	hash = JSON.parse cookies[:tempo_organiser]
			# 	rank = params[:id]
			# 	checkout = hash["checkouts"][rank]
			# 	swap_down({rank => checkout})	
			# end

			# if params[:commit] == "change"
			# 	checkout = Checkout.find(params[:ticket][:checkout_id])
			# 	ticket = Ticket.find(params[:ticket][:id])
			# 	checkout.ticket_id = ticket.id	
			# end

			# if params[:commit] == "Select this activity"
				
			# 	rank = params["ticket"]["rank"]
			# 	hash = JSON.parse cookies[:tempo_organiser]
			# 	hash["checkouts"][rank]["selected"] = true
			# 	hash["checkouts"][rank]["ticket_id"] = params[:ticket][:id]
			# 	hash["checkouts"][rank]["day"] = session[:current_day]
			# 	hash["checkouts"][rank]["index"] = last_index + 1
			# 	cookies[:tempo_organiser] = JSON.generate hash
				
			# end

			# if params[:commit] == "unselect"
			# 	update_checkouts_after_unselect(params[:id])
			# end

		#update_checkout(params[:index].to_i)
	end

	
	def set_index(current_day)

			checkouts = Checkout.where(organiser_id: self.organiser_id, day: current_day).order(:index)
			if	checkouts.size == 0
				return 1
			else
				return (checkouts.last.index.to_i + 1)
			end

		# else

		# 	return checkout.values.first["index"]

		# end
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
