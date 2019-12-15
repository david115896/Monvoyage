class StaticController < ApplicationController
  def index
    @cities = City.all
		# reset_cookies
		check_cookies
  end
end
