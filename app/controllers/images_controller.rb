class ImagesController < ApplicationController
    def create
        @activity = Activity.find(params[:activity_id])
        @activity.image.attach(params[:image])
        redirect_to(root_path)
    end
  
  end