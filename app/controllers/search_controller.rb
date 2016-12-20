class SearchController < ApplicationController
  def index
  end

  def query
    if request.xhr?
      @locations = Location.pluck(:latitude, :longitude)
      render :json => @locations
    end
  end
end
