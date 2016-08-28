class ReservationsController < ApplicationController

  def create
    args = params.require(:data).require(:attributes).permit([:suite_id, :client_id, :start_date, :end_date, :number_of_people, :comment])
    args.tap do |attrs|
      attrs.require([:suite_id, :client_id, :start_date, :end_date, :number_of_people])
    end
    @reservation = Reservation.new(args)
    @reservation.save
    @json = JsonObject.new @reservation
    render json:@json
  end
end
