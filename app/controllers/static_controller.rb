class StaticController < ApplicationController
  def index
    @cities = City.all
     # session[:user_id] = {id: (User.last.id + 1)}
      #cookies.encrypted[:username] = "John"      
     # cookies.delete(:username)

  end
end
