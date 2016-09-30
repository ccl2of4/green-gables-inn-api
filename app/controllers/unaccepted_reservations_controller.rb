class UnacceptedReservationsController < ApplicationController

  http_basic_authenticate_with name: Rails.configuration.username,
    password: Rails.configuration.password

  def index
    @reservations = Reservation.where('accepted IS NOT true')
    @json = JsonObject.new @reservations
    render json:@json
  end

  def show
    @reservation = Reservation.where('accepted IS NOT true').find(params[:id])
    @json = JsonObject.new @reservation
    render json:@json
  end

  def destroy
    @reservation = Reservation.where('accepted IS NOT true').find(params[:id])
    @reservation.destroy
  end

  def update
    @reservation = Reservation.find(params[:id])
    @reservation.update(accepted: false)
    @reservation.save
    @json = JsonObject.new @reservation
    render json:@json
  end

end
