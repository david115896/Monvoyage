class StaticController < ApplicationController
  def index
    @cities = City.all
		@city = City.all.sample
     # session[:user_id] = {id: (User.last.id + 1)}
      #cookies.encrypted[:username] = "John"      
     # cookies.delete(:username)
    @activities = activity.all
  end
end
