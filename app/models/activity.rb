class Activity < ApplicationRecord
	belongs_to :activities_category
	belongs_to :city

	has_many :tickets
	has_many :checkouts, through: :tickets

	geocoded_by :address
	after_validation :geocode, :if => lambda{ |obj| obj.address_changed? }	

	validates :name, presence: true, uniqueness: true, format: {with: /\A[^*!@%\^]+\z/}, length: {in: 5..100}
	validates :address, presence: true, format: {with: /\A[^*!@%\^]+\z/}, length: {in: 5..100}
	validates :description, presence: true, format: {with: /\A[^*!@%\^]+\z/}, length: {in: 20..10000}
	validates :picture, presence: true
	validates :latitude , presence: true, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
	validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

	has_one_attached :image

	def self.update(params, checkouts_id)
		if params[:commit] == "Go"
			return Activity.where(city_id: params[:city][:id], activities_category: ActivitiesCategory.find_by(name: "Landmarks"))	
		elsif params[:commit] == "Search"
			selected_category_id = params[:city][:activities_category_id]
			return Activity.where(city_id: params[:city_id], activities_category_id: selected_category_id)
		elsif params[:commit] == "my_activities"
				return get_my_activities(checkouts_id)
		else
			return Activity.where(city_id: params[:city_id], activities_category: ActivitiesCategory.find_by(name: "Landmarks"))	
		end
	end

	def self.update_session(params, hash_tempo)
		if params[:commit] == "Go"
			return Activity.where(city_id: params[:city][:id], activities_category: ActivitiesCategory.find_by(name: "Landmarks"))	
		elsif params[:commit] == "Search"
			selected_category_id = params[:city][:activities_category_id]
			return Activity.where(city_id: params[:city_id], activities_category_id: selected_category_id)
		elsif params[:commit] == "my_activities"
				return get_my_activities_session(hash_tempo)
		else
			return Activity.where(city_id: params[:city_id], activities_category: ActivitiesCategory.find_by(name: "Landmarks"))	
		end
	end

	def self.show_update(params)
		if params[:commit] == "my_activities"
			return true
		else
			return false
		end
	end

	def self.get_my_activities(checkouts_id)
		return Activity.joins(:checkouts).where("checkouts.id IN (?)", checkouts_id)
	end

	def self.get_my_activities_session(hash_tempo)
		tickets_id = Ticket.get_tickets_id_session(hash_tempo["checkouts"])
		return Activity.joins(:tickets).where("tickets.id IN (?)", tickets_id)
	end
		
	def self.import(file, city_id)
    	CSV.foreach(file.path, headers: true) do |row|
			activities_hash = row.to_hash
			activities_hash[:city] = City.find_by(name: row[4])
			activities_hash[:activities_category] = ActivitiesCategory.where(name: row[5]).first
			Activity.create! activities_hash
		end
	end
	
	# def self.amount(cart_activities)
        # amount = 0
        # cart_activities.each do |activity|
            # amount += activity.price
        # end
        # return amount
	# end
	
end
