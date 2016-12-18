require 'test_helper'

class ReservationsControllerTest < ActionDispatch::IntegrationTest

  test 'basic auth' do
    # Reservations
    get reservations_url
    assert_response :unauthorized
    get reservation_url(reservation_id=1)
    assert_response :unauthorized
  end

  test 'create reservation' do
    get suites_url
    suite_id = get_json(response)['data'][0]['id']

    get clients_url, with_auth
    client_id = get_json(response)['data'][0]['id']

    reservation = Reservation.new
    reservation.suite_id = suite_id
    reservation.client_id = client_id
    reservation.start_date = DateTime.now()
    reservation.end_date = DateTime.now()
    reservation.number_of_people = '10'
    reservation.comment = 'a comment'
    input = JsonObject.new reservation

    post reservations_url, params:input.json

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

  test 'cannot create reservation without client or suite' do
    get suites_url
    suite_id = get_json(response)['data'][0]['id']

    get clients_url, with_auth
    client_id = get_json(response)['data'][0]['id']

    reservation = Reservation.new
    reservation.start_date = DateTime.now()
    reservation.end_date = DateTime.now()
    reservation.number_of_people = '10'
    reservation.comment = 'a comment'

    reservation.client_id = 'fake'
    reservation.suite_id = 'also fake'
    input = JsonObject.new reservation
    post '/reservations', params:input.json
    assert_response :not_found

    reservation.client_id = client_id
    input = JsonObject.new reservation
    post '/reservations', params:input.json
    assert_response :not_found

    reservation.client_id = 'fake again'
    reservation.suite_id = suite_id
    input = JsonObject.new reservation
    post '/reservations', params:input.json
    assert_response :not_found
  end

  test 'get all reservations contains both unaccepted and accepted' do
    get reservations_url, with_auth
    assert_response :success
    json = get_json(response)
    unaccepted = json['data'].find {|obj| obj['attributes']['accepted'] == false}
    accepted = json['data'].find {|obj| obj['attributes']['accepted'] == true}

    assert_not_nil unaccepted
    assert_not_nil accepted
  end

  test 'unaccepted_reservations only contains unaccepted reservations' do
    get reservations_url, with_auth(hash:{params:{accepted:false}})
    assert_response :success

    json = get_json(response)
    json['data'].each do |obj|
      assert obj['attributes']['accepted'] == false
    end
  end

  test 'newly created reservation defaults to unaccepted' do
    get suites_url
    suite_id = get_json(response)['data'][0]['id']

    get clients_url, with_auth
    client_id = get_json(response)['data'][0]['id']

    reservation = Reservation.new
    reservation.suite_id = suite_id
    reservation.client_id = client_id
    reservation.start_date = DateTime.now()
    reservation.end_date = DateTime.now()
    reservation.number_of_people = '10'
    reservation.comment = 'a comment'
    input = JsonObject.new reservation
    post reservations_url, params:input.json
    id = get_id(response)

    get reservations_url, with_auth(hash:{params:{accepted:true}})
    json = get_json(response)
    match = json['data'].find do |obj|
      return obj['id'] == id
    end
    assert_not_nil match
  end

  test 'accepted_reservations only contains accepted reservations' do
    get reservations_url, with_auth(hash:{params:{accepted:true}})
    assert_response :success

    json = get_json(response)
    json['data'].each do |obj|
      assert obj['attributes']['accepted'] == true
    end
  end

  test 'accept a reservation' do
    get reservations_url, with_auth(hash:{params:{accepted:false}})
    reservation = {'data' => get_json(response)['data'][0]}
    id = reservation['data']['id']
    reservation['data']['attributes']['accepted'] = true

    patch reservation_url(reservation_id=id), with_auth(hash:{params:reservation})
    assert_response :success

    get reservation_url(reservation_id=id), with_auth
    assert_response :success
    reservation = {'data' => get_json(response)['data']}
    assert reservation['data']['attributes']['accepted'] == true
  end

  test 'undo accepting a reservation' do
    get reservations_url, with_auth(hash:{params:{accepted:false}})
    reservation = {'data' => get_json(response)['data'][0]}
    id = reservation['data']['id']
    reservation['data']['attributes']['accepted'] = true

    patch reservation_url(reservation_id=id), with_auth(hash:{params:reservation})
    assert_response :success

    get reservation_url(reservation_id=id), with_auth
    assert_response :success
    reservation = {'data' => get_json(response)['data']}
    assert reservation['data']['attributes']['accepted'] == true


    reservation['data']['attributes']['accepted'] = false

    patch reservation_url(reservation_id=id), with_auth(hash:{params:reservation})
    assert_response :success

    get reservation_url(reservation_id=id), with_auth
    assert_response :success
    reservation = {'data' => get_json(response)['data']}
    assert reservation['data']['attributes']['accepted'] == false
  end

end
