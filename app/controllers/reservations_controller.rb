class ReservationsController < ApplicationController

  # Creates a new reservation with accepted=false
  def create
    attrs = get_reservation_attrs(params)
    @reservation = Reservation.new(attrs)
    @reservation.save
    @json = JsonObject.new @reservation
    render json:@json
  end

  private def get_reservation_attrs(params)
    params.require(:data)
          .require(:attributes)
          .permit([:suite_id, :client_id, :start_date, :end_date, :number_of_people, :comment])
          .tap {|attrs| attrs.require([:suite_id, :client_id, :start_date, :end_date, :number_of_people])}
  end

end
