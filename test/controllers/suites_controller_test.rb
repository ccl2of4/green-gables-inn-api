require 'test_helper'

class SuitesControllerTest < ActionDispatch::IntegrationTest

  test 'get suites' do
    get '/suites'
    assert_response :success
    json = get_json(response)
    assert json['data'].length == 2
  end

  test 'check attributes' do
    get '/suites'
    attrs = get_json(response)['data'][0]['attributes']
    assert_not_nil attrs['name']
    assert_not_nil attrs['price']
    assert_not_nil attrs['created_at']
    assert_not_nil attrs['updated_at']
    assert attrs.size == 4
  end

  test 'get suite' do
    get '/suites'
    id = get_json(response)['data'][0]['id']

    get "/suites/#{id}"
    assert_response :success
    assert get_id(response) == id
  end

  test 'create suite' do
    suite = Suite.new
    suite.name = 'name'
    input = JsonObject.new suite
    post '/suites', params:input.json
    assert_response :success
    assert_not_nil get_id(response)

    attrs_in = get_attrs(input)
    attrs_out = get_attrs(response)

    assert attrs_out['name'] == attrs_in['name']
  end

  test 'update suite' do
    get '/suites'
    suite = get_json(response)
    # Flattens the suite to be used as a request object
    suite['data'] = suite['data'][0]
    suite['data']['attributes']['name'] = 'new name!'
    id = get_id(suite)

    patch "/suites/#{id}", params:suite
    assert_response :success
    assert get_attrs(response)['name'] == 'new name!'
  end

  test 'destroy suite' do
    get '/suites'
    id = get_json(response)['data'][0]['id']

    delete "/suites/#{id}"
    assert_response :no_content

    get "/suites/#{id}"
    assert_response :not_found
  end

end
