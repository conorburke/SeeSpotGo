class ReservationsController < ApplicationController
  def create
    @reservation = Reservation.create(reservation_params)
    redirect_to location_path(@reservation.space.location_id)
  end

  def reservation_params
    params.require(:reservation).permit(:start_time, :end_time).merge(space_id: params[:space_id], occupant_id: current_user.id)
  end
end
