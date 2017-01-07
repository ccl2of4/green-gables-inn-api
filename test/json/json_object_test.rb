require 'test_helper'

class JsonObjectTest < ActiveSupport::TestCase
  test 'single object' do
    suite = Suite.new
    suite.id = 1
    suite.name = 'name'
    suite.price = 450

    json = JsonObject.new(suite).json
    assert json['data'].kind_of? Hash
    assert json['data']['id'] == 1
    assert json['data']['attributes'].kind_of? Hash
    assert json['data']['attributes']['name'] == 'name'
    assert json['data']['attributes']['price'] == 450
  end

  test 'single object, exclude attribute' do
    suite = Suite.new
    suite.id = 1
    suite.name = 'name'
    suite.price = 450

    json = JsonObject.new(suite, exclude=['price'].to_set).json
    assert json['data'].kind_of? Hash
    assert json['data']['id'] == 1
    assert json['data']['attributes'].kind_of? Hash
    assert json['data']['attributes']['name'] == 'name'
    assert !json['data']['attributes'].has_key?('price')
  end

  test 'collection' do
    suites = (1..5).map do |i|
      suite = Suite.new
      suite.id = i
      suite.name = 'name'
      suite
    end

    json = JsonObject.new(suites).json
    assert json['data'].kind_of? Array
    assert json['data'][0]['id'] == 1
    assert json['data'][1]['id'] == 2
    assert json['data'][0]['attributes'].kind_of? Hash
    assert json['data'][0]['attributes']['name'] == 'name'

  end

  test 'relationships' do
    reservation = Reservation.new
    reservation.start_date = DateTime.now()
    reservation.end_date = DateTime.now()
    reservation.number_of_people = '10'
    reservation.comment = 'a comment'

    suite = Suite.new
    suite.id = 1

    client = Client.new
    client.id = 2

    json = JsonObject.new(reservation)
      .relationship('suite', suite)
      .relationship('client', client)
      .json

    assert json['data']['attributes']['comment'] = 'a comment'
    assert json['data']['relationships']['suite']['data']['id'] == 1
    assert json['data']['relationships']['client']['data']['id'] == 2
  end

end
