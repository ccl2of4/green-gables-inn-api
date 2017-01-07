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
    reservation.start_date = DateTime.now()
    reservation.end_date = DateTime.now()
    reservation.number_of_people = '10'
    reservation.comment = 'a comment'

    client = Client.new
    client.id = client_id

    suite = Suite.new
    suite.id = suite_id

    input = JsonObject.new(reservation)
      .relationship('client', client)
      .relationship('suite', suite)

    post reservations_url, params:input.json

    assert_response :success

    id = get_id(response)
    assert_not_nil id

    attrs_in  = get_attrs(input)
    attrs_out = get_attrs(response)
    json_out = get_json(response)

    assert attrs_out['number_of_people']          == attrs_in['number_of_people']
    assert attrs_out['comments']                  == attrs_in['comments']
    assert get_timestamp(attrs_out['start_date']) ==
      get_timestamp(attrs_in['start_date'])
    assert get_timestamp(attrs_out['end_date'])   ==
      get_timestamp(attrs_in['end_date'])

    assert json_out['data']['relationships']['client']['data']['id'] == client_id
    assert json_out['data']['relationships']['suite']['data']['id']  == client_id
    assert !json_out['data']['attributes'].has_key?('suite_id')
    assert !json_out['data']['attributes'].has_key?('client_id')
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

  test 'get all reservations is in correct format' do
    get reservations_url, with_auth
    assert_response :success
    json = get_json(response)
    json['data'].each do |obj|
      assert !obj['attributes'].has_key?('client_id')
      assert !obj['attributes'].has_key?('suite_id')

      # TODO
      #assert obj.has_key?('relationships')
      #assert obj['relationships'].has_key?('client')
      #assert obj['relationships'].has_key?('suite')
      #assert obj['relationships']['client']['data'].has_key?('id')
      #assert obj['relationships']['suite']['data'].has_key?('id')
    end
  end

  test 'get reservation is in correct format' do
    get reservations_url, with_auth
    reservation_id = get_json(response)['data'][0]['id']

    get reservation_url(reservation_id), with_auth

    json = get_json(response)
    assert !json['data']['attributes'].has_key?('client_id')
    assert !json['data']['attributes'].has_key?('suite_id')
    assert json['data'].has_key?('relationships')
    assert json['data']['relationships'].has_key?('client')
    assert json['data']['relationships'].has_key?('suite')
    assert json['data']['relationships']['client']['data'].has_key?('id')
    assert json['data']['relationships']['suite']['data'].has_key?('id')
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
    reservation.start_date = DateTime.now()
    reservation.end_date = DateTime.now()
    reservation.number_of_people = '10'
    reservation.comment = 'a comment'

    client = Client.new
    client.id = client_id

    suite = Suite.new
    suite.id = suite_id

    input = JsonObject.new(reservation)
      .relationship('client', client)
      .relationship('suite', suite)

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
