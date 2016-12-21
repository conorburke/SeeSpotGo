class LocationsController < ApplicationController
  def create
    @location = Location.create(location_params)
    redirect_to user_path(@location.user_id)
  end

  def show
    @location = Location.find_by_id(params[:id])
    @user = User.find_by_id(@location.user_id)

    # @location_data = {
    #   latitude: @location.latitude,
    #   longitude: @location.longitude,
    #   infobox: (render_to_string("search/_infobox", layout: false, locals: {location: @location}))
    # }
    #   # @results = @locations.map do |location|
    #   #   { latitude: location.latitude,
    #   #     longitude: location.longitude,
    #   #     infobox: (render_to_string("search/_infobox", layout: false, locals: {location: location})) }
    #   # end
    #   render :json => @location_data
  end

  def reservation_params
    params.require(:location).permit(:street_address, :city, :state, :zip).merge(user_id: current_user.id)
  end
end
