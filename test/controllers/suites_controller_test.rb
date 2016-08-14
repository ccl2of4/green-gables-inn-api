require 'test_helper'

class SuitesControllerTest < ActionDispatch::IntegrationTest

  test 'get suites' do
    get '/suites'
    assert_response :success
    json = JSON.parse(response.body)
    assert json['data'].length == 2
  end

  test 'check attributes' do
    get '/suites'
    json = JSON.parse(response.body)
    attrs = json['data'][0]['attributes']
    assert_not_nil attrs['name']
    assert_not_nil attrs['price']
    assert_not_nil attrs['created_at']
    assert_not_nil attrs['updated_at']
    assert attrs.size == 4
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

  test 'update suite' do
    get '/suites'
    suite = JSON.parse(response.body)
    suite['data'][0]['attributes']['name'] = 'new name!'
    suite['data'] = suite['data'][0]
    id = suite['data']['id']

    patch "/suites/#{id}", params:suite
    assert_response :success
    json = JSON.parse(response.body)
    assert json['data']['attributes']['name'] == 'new name!'
  end

  test 'destroy suite' do
    get '/suites'
    suite = JSON.parse(response.body)
    suite['data'][0]['attributes']['name'] = 'new name!'
    suite['data'] = suite['data'][0]
    id = suite['data']['id']

    delete "/suites/#{id}", params:suite
    assert_response :no_content

    get "/suites/#{id}"
    assert_response :not_found
  end

end
