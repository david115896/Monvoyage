class Admin::OrganisersController < ApplicationController
	before_action :authenticate_admin

	def index
		@organisers = Organiser.all
	end

end