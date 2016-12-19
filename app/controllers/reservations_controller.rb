class ReservationsController < ApplicationController
  def create
    @reservation = Reservation.create(start_time: params[:start_time], end_time: params[:end_time])
    @space = Space.find(@reservation.space_id)
    render space_path(@space)
  end
end
