class SpacesController < ApplicationController
  def show
    @space = Space.find_by_id(params[:id])
    @location = @space.location
    @owner = User.find_by_id(@location.user_id)
    @users_reservations = @space.reservations.where("occupant_id = ?", current_user.id)
    @reservation = Reservation.new()
  end
end
