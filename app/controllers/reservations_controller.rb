class ReservationsController < ApplicationController
  def create
    @space = Space.find(params[:space_id])
    @space.reservations.create(start_time: params[:start_time], end_time: params[:end_time])
    redirect_to space_path(@space)
  end
end
