class UnacceptedReservationsController < ApplicationController

  def index
    @reservations = Reservation.where(accepted: false)
    @json = JsonObject.new @reservations
    render json:@json
  end

end
