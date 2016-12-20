class SpacesController < ApplicationController
  def show
    @space = Space.find_by_id(params[:id])
    @location = @space.location
    @reservation = Reservation.new(space_id: @space.id, occupant_id: current_user.id)
  end
end
