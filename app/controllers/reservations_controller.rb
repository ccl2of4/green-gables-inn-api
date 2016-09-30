class ReservationsController < ApplicationController

  http_basic_authenticate_with name: Rails.configuration.username,
    password: Rails.configuration.password,
    except: :create

  def index
    @reservations = Reservation.all
    @json = JsonObject.new @reservations
    render json:@json
  end

  def show
    @reservation = Reservation.find(params[:id])
    @json = JsonObject.new @reservation
    render json:@json
  end

  # Creates a new reservation that will default to not accepted
  def create
    attrs = get_reservation_attrs(params)
    @reservation = Reservation.new(attrs)

    # Throw 404 if the associated suite and client don't exist.
    Suite.find(@reservation.suite_id)
    Client.find(@reservation.client_id)

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
