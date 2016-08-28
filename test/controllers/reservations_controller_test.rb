require 'test_helper'

class ReservationsControllerTest < ActionDispatch::IntegrationTest

  test 'create reservation' do
    reservation = Reservation.new
    reservation.suite_id = '1'
    reservation.client_id = '1'
    reservation.start_date = DateTime.now()
    reservation.end_date = DateTime.now()
    reservation.number_of_people = '10'
    reservation.comment = 'a comment'
    input = JsonObject.new reservation
    post '/reservations', params:input.json

    assert_response :success

    id = get_id(response)
    assert_not_nil id

    attrs_in  = get_attrs(input)
    attrs_out = get_attrs(response)

    assert attrs_out['suite_id']                  == attrs_in['suite_id']
    assert attrs_out['client_id']                 == attrs_in['client_id']
    assert attrs_out['number_of_people']          == attrs_in['number_of_people']
    assert attrs_out['comments']                  == attrs_in['comments']
    assert get_timestamp(attrs_out['start_date']) ==
      get_timestamp(attrs_in['start_date'])
    assert get_timestamp(attrs_out['end_date'])   ==
      get_timestamp(attrs_in['end_date'])
  end

end
