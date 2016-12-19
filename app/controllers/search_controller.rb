class SearchController < ApplicationController
  def index
  end

  def search
    @location = params[:search]
    @distance = params[:miles]
    @locations = Location.near(@location, @distance)

    if @location.empty?
      flash notice: "Must enter a search location"
      redirect_to "/"
    else
      if @locations.length < 1
        flash notice: "There are no locations in that range"
        redirect_to "/"
      else
        search_map(@locations)
      end
    end
  end


  private

  def search_map(locations)
    @locations = locations
    @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
      marker.lat location.latitude
      marker.lng location.longitude
      marker.infowindow "<a herf='/locations/"+"#{location.id}"+"'>#{location.street_address}, #{location.city}, #{location.state}, #{location.zip}</a>"
      # marker.json({ id: location.id})
    end
  end
end
