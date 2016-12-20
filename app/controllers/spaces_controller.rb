class SpacesController < ApplicationController
  def show
    @space = Space.find(params[:id])
    @location = Location.find(@space.location_id)
    @reservation = Reservation.new(space_id: @space.id, occupant_id: current_user.id)
  end
end
