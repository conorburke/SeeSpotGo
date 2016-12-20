class SearchController < ApplicationController
  def index
  end

  def query
    if request.xhr?
      # Check Input.
      @location = params[:search]
      @distance = params[:miles]
      unless @location && !@location.empty?
        return render :json => { :fail => "No available parking spots in range." }
      end

      # Search all locations within rage.
      @locations = Location.near(@location, @distance)
      @locations = @locations.select { |location| location.active_spaces.count != 0 }

      unless @locations.empty?
        @results = @locations.map do |location|
          { latitude: location.latitude,
            longitude: location.longitude,
            infobox: (render_to_string("search/_infobox", layout: false, locals: {location: location})) }
        end
        render :json => @results
      else
        render :json => { :fail => "No available parking spots in range." }
      end
    end
  end
end
