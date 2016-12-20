class SearchController < ApplicationController
  def index
  end

  def query
    if request.xhr?
      @locations = Location.all
      @results = @locations.map do |location|
        { latitude: location.latitude,
          longitude: location.longitude,
          infobox: (render_to_string("search/_infobox", layout: false, locals: {location: location})) }
      end
      render :json => @results
    end
  end
end
