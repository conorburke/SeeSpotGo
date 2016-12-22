class LocationsController < ApplicationController
  def new
    @location = Location.new
    render :json => { :location_form => (render_to_string("locations/_form", layout: false)) }
  end

  def create
    @location = Location.create(location_params)
    @locations = current_user.locations || []
    render :json => { :space_form => (render_to_string("spaces/_form", layout: false, locals: {location: @location, space: Space.new})),
                      :location_selector => (render_to_string("home/_location_selector", layout: false)),
                      :location_id => @location.id }
    @chat_room = ChatRoom.create(title: @location.street_address, location_id: @location.id)
  end

  def show
    @location = Location.find_by_id(params[:id])
    @user = User.find_by_id(@location.user_id)
    @reservation = Reservation.new()
    @chat_room = ChatRoom.includes(:messages).find_by(id: @location.id)
    @message = Message.new
  end

  def update
  end

  def location_params
    params.require(:location).permit(:street_address, :city, :state, :zip).merge(user_id: current_user.id)
  end
end
