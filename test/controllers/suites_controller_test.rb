require 'test_helper'

class SuitesControllerTest < ActionDispatch::IntegrationTest
  test 'get suites' do
    get '/suites'
    assert_response :success
    json = JSON.parse(response.body)
    assert json['data'].length == 2
  end

  test 'get suite' do
    get '/suites'
    id = JSON.parse(response.body)['data'][0]['id']

    get "/suites/#{id}"
    assert_response :success
    json = JSON.parse(response.body)
    assert json['data']['id'] == id
  end

  test 'create suite' do
    suite = Suite.new
    suite.name = 'name'
    input = JsonObject.new suite
    post '/suites', params:input.json
    assert_response :success
    output = JSON.parse(response.body)
    assert output['data'].kind_of? Hash
    assert output['data']['attributes'].kind_of? Hash
    assert_not_nil output['data']['id']
    assert output['data']['attributes']['name'] == input.json['data']['attributes']['name']
  end

end
