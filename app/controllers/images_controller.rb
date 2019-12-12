class ImagesController < ApplicationController
    def create
        @activity = Activity.find(params[:activity_id])
        @activity.picture.attach(params[:picture])
        redirect_to(root_path)
    end
  
  end