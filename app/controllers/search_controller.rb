class SearchController < ApplicationController
  def index
  end

  def query
    # Check Input.
    search = Search.new(search_params)
    unless search.valid?
      return render :json => { :fail => search.errors.first }
    end

    # Search all locations within rage.
    @locations = search.search_locations

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

  private

  def search_params
    { search: params[:search],
      miles: params[:miles],
      size: params[:size],
      constrain: params[:constrain],
      price: params[:price],
      start_time: params[:start_time],
      end_time: params[:end_time] }
  end
end
