class Admin::OrdersController < ApplicationController
	before_action :authenticate_admin

	def index
		@orders = Order.all
	end

	def show
		@tickets = Order.find(params[:id]).tickets
	end

end
