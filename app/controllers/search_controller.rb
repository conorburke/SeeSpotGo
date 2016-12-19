class SearchController < ApplicationController
  def index
    @locations = Location.pluck(:latitude, :longitude)
  end
end
