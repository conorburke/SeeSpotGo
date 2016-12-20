class ReservationsController < ApplicationController
  def create
    @space = Space.find_by_id(params[:space_id])
    @space.reservations.create(start_time: params[:reservation][:start_time], end_time: params[:reservation][:end_time], occupant_id: current_user.id)
    redirect_to space_path(@space)
  end
end
