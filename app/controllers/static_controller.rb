class StaticController < ApplicationController
  def index
    if current_city== nil
      current_city = City.all.sample
    end
    @cities = City.all
		@city = City.all.sample
		
		reset_cookies	
		
  end

end
