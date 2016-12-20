class RatingsController < ApplicationController
  def create
    @reservation = Reservation.find_by_id(params[:reservation_id])
    @rater_id = @reservation.occupant_id
    @user_id = @reservation.space.location.user_id
    @rating = Rating.create({score: params[:score], reservation_id: params[:reservation_id], rater_id: @rater_id, user_id: @user_id})
    redirect_to space_path(@reservation.space_id)
  end
end
