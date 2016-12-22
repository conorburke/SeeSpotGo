class SpacesController < ApplicationController
  # def show
  #   @space = Space.find_by_id(params[:id])
  #   @location = @space.location
  #   @owner = User.find_by_id(@location.user_id)
  #   @users_reservations = @space.reservations.where("occupant_id = ?", current_user.id)
  #   @reservation = Reservation.new()
  # end

  def new
    @space = Space.new({size: "standard", price: 2, space_active: 1})
    @location = Location.find_by_id(params[:location_id])
    render :json => { :space_form => (render_to_string("spaces/_form", layout: false, locals: {location: @location, space: @space})) }
  end

  def create
    @space = Space.create(space_params)
    redirect_to @space.location
  end

  def edit
    @location = Location.find_by_id(params[:location_id])
    @space = Space.find_by_id(params[:id])
    render :json => { :edit_form => (render_to_string("spaces/_form", layout: false, locals: {location: @location, space: @space})) }
  end

  def update
    @space = Space.find_by_id(params[:id])
    @space.update(space_params)
    redirect_to @space.location
  end

  def space_params
    params.require(:space).permit(:size, :price, :description, :space_active).merge(location_id: params[:location_id])
  end

end
