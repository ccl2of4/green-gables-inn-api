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

  test 'collection' do
    suites = []
    (1..5).each do |i|
      suite = Suite.new
      suite.id = i
      suite.name = 'name'
      suites.push suite
    end

    json = JsonObject.new(suites).json
    assert json['data'].kind_of? Array
    assert json['data'][0]['id'] == 1
    assert json['data'][1]['id'] == 2
    assert json['data'][0]['attributes'].kind_of? Hash
    assert json['data'][0]['attributes']['name'] == 'name'

  end

end
