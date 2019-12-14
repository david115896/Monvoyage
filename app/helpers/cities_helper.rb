module CitiesHelper

	def first_city
		return Organiser.first.city
	end

	def get_Seoul
		return City.find_by(name: "Seoul")
	end

	def get_Tokyo
		return City.find_by(name: "Tokyo")
	end

	def get_Rio
		return City.find_by(name: "Rio De Janeiro")
	end

	def get_Roma
		return City.find_by(name: "Roma")
	end

	def get_Seville
		return City.find_by(name: "Seville")
	end

end
