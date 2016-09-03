class AcceptedReservationsController < ApplicationController

  http_basic_authenticate_with name: Rails.configuration.username,
    password: Rails.configuration.password

  def index
    @reservations = Reservation.where(accepted: true)
    @json = JsonObject.new @reservations
    render json:@json
  end

  def show
    @reservation = Reservation.where(accepted: true).find(params[:id])
    @json = JsonObject.new @reservation
    render json:@json
  end

  def update
    @reservation = Reservation.find(params[:id])
    @reservation.update(accepted: true)
    @reservation.save
    @json = JsonObject.new @reservation
    render json:@json
  end

end
