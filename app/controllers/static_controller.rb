class StaticController < ApplicationController
  def index
    @cities = City.all
  end
end
