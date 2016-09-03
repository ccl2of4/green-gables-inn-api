class UnacceptedReservationsController < ApplicationController

  def index
    @reservations = Reservation.where(accepted: false)
    @json = JsonObject.new @reservations
    render json:@json
  end

  def show
    @reservation = Reservation.where(accepted: false).find(params[:id])
    @json = JsonObject.new @reservation
    render json:@json
  end

  def destroy
    @reservation = Reservation.where(accepted: false).find(params[:id])
    @reservation.destroy
  end

end
