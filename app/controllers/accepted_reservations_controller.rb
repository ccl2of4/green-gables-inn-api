class AcceptedReservationsController < ApplicationController

  def index
    @reservations = Reservation.where(accepted: true)
    @json = JsonObject.new @reservations
    render json:@json
  end

end
