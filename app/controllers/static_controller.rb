class StaticController < ApplicationController
  def index
    @cities = City.all
		@city = City.all.sample
		@organiser = Organiser.new
		if cookies[:organiser_id]
			cookies[:organiser_id] = Organiser.all.sample
		end
     # session[:user_id] = {id: (User.last.id + 1)}
      #cookies.encrypted[:username] = "John"      
     # cookies.delete(:username)

  end
end
