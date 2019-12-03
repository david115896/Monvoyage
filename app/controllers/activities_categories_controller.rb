class ActivitiesCategoriesController < ApplicationController
    def index
        @categories = ActivitiesCategory.all
    end   
end
