class Admin::OrdersController < ApplicationController
	
	def index
		@orders = Order.all
	end

	def show
		@tickets = Order.find(params[:id]).tickets
	end

end
