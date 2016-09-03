require 'test_helper'

# Has tests for reservations, accepted_reservations, and unaccepted_reservations
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

  test 'get all reservations contains both unaccepted and accepted' do
    get '/reservations'
    assert_response :success
    json = get_json(response)

    unaccepted = json['data'].find {|obj| obj['attributes']['accepted'] == false}
    accepted = json['data'].find {|obj| obj['attributes']['accepted'] == true}

    assert_not_nil unaccepted
    assert_not_nil accepted
  end

  test 'unaccepted_reservations only contains unaccepted reservations' do
    get '/unaccepted_reservations'
    assert_response :success

    json = get_json(response)
    json['data'].each do |obj|
      assert obj['attributes']['accepted'] == false
    end
  end

  test 'newly created reservation defaults to unaccepted' do
    reservation = Reservation.new
    reservation.suite_id = '1'
    reservation.client_id = '1'
    reservation.start_date = DateTime.now()
    reservation.end_date = DateTime.now()
    reservation.number_of_people = '10'
    reservation.comment = 'a comment'
    input = JsonObject.new reservation
    post '/reservations', params:input.json
    id = get_id(response)

    get '/unaccepted_reservations'
    json = get_json(response)
    match = json['data'].find do |obj|
      return obj['id'] == id
    end
    assert_not_nil match
  end

  test 'accepted_reservations only contains accepted reservations' do
    get '/accepted_reservations'
    assert_response :success

    json = get_json(response)
    json['data'].each do |obj|
      assert obj['attributes']['accepted'] == true
    end
  end

  test 'find accepted reservation by id' do
    get '/accepted_reservations'
    id = get_json(response)['data'][0]['id']

    get "/accepted_reservations/#{id}"
    assert_response :success
  end

  test 'unaccepted reservations dont show up as accepted' do
    get '/unaccepted_reservations'
    id = get_json(response)['data'][0]['id']

    get "/accepted_reservations/#{id}"
    assert_response :not_found
  end

  test 'find unaccepted reservation by id' do
    get '/unaccepted_reservations'
    id = get_json(response)['data'][0]['id']

    get "/unaccepted_reservations/#{id}"
    assert_response :success
  end

  test 'accepted reservations dont show up as unaccepted' do
    get '/accepted_reservations'
    id = get_json(response)['data'][0]['id']

    get "/unaccepted_reservations/#{id}"
    assert_response :not_found
  end

  test 'accept a reservation' do
    get '/unaccepted_reservations'
    id = get_json(response)['data'][0]['id']

    get "/unaccepted_reservations/#{id}"
    assert_response :success
    get "/accepted_reservations/#{id}"
    assert_response :not_found

    put "/accepted_reservations/#{id}"
    assert_response :success

    get "/unaccepted_reservations/#{id}"
    assert_response :not_found
    get "/accepted_reservations/#{id}"
    assert_response :success
  end

  test 'delete an unaccepted reservation' do
    get '/unaccepted_reservations'
    id = get_json(response)['data'][0]['id']

    get "/reservations/#{id}"
    assert_response :success
    get "/unaccepted_reservations/#{id}"
    assert_response :success

    delete "/unaccepted_reservations/#{id}"
    assert_response :no_content

    get "/reservations/#{id}"
    assert_response :not_found
    get "/unaccepted_reservations/#{id}"
    assert_response :not_found
  end

end
