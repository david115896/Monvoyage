class Admin::CitiesController < ApplicationController
	before_action :authenticate_admin

	def index
		@cities = City.all
	end

end
