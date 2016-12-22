class SpacesController < ApplicationController
  # def show
  #   @space = Space.find_by_id(params[:id])
  #   @location = @space.location
  #   @owner = User.find_by_id(@location.user_id)
  #   @users_reservations = @space.reservations.where("occupant_id = ?", current_user.id)
  #   @reservation = Reservation.new()
  # end

  def new
    @location = Location.find_by_id(params[:location_id])
    @space = Space.new()
  end

  def create
    @space = Space.create(space_params)
    redirect_to locations_path(@space.location_id)
  end

  def space_params
    params.require(:space).permit(:size, :description, :space_active).merge(location_id: params[:location_id])
  end

end
