class StaticController < ApplicationController
  def index
    @cities = City.all
		@city = City.all.sample
		
		reset_cookies	
		set_cookies
		
  end

end
