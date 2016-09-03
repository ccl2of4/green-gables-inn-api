require 'test_helper'

class ClientsControllerTest < ActionDispatch::IntegrationTest

  test 'get clients' do
    get '/clients'
    assert_response :success
    json = get_json(response)
    assert json['data'].length == 2
  end

  test 'check attributes' do
    get '/clients'
    attrs = get_json(response)['data'][0]['attributes']
    assert_not_nil attrs['full_name']
    assert_not_nil attrs['email_address']
    assert_not_nil attrs['phone_number']
    assert_not_nil attrs['created_at']
    assert_not_nil attrs['updated_at']
    assert attrs.size == 5
  end

  test 'get client' do
    get '/clients'
    id = get_json(response)['data'][0]['id']

    get "/clients/#{id}"
    assert_response :success
    assert get_id(response) == id
  end

  test 'create client' do
    client = Client.new
    client.full_name = 'name'
    client.email_address = 'email'
    client.phone_number = 'phone'
    input = JsonObject.new client
    post '/clients', params:input.json
    assert_response :success

    id = get_id(response)
    assert_not_nil id

    attrs_out = get_attrs(response)
    attrs_in = get_attrs(input)

    assert attrs_out['name'] == attrs_in['name']
    assert attrs_out['email_address'] == attrs_in['email_address']
    assert attrs_out['phone_number'] == attrs_in['phone_number']
  end

  test 'required attributes for create client' do
    client = Client.new
    client.email_address = 'email'
    client.phone_number = 'phone'
    input = JsonObject.new client
    post '/clients', params:input.json
    assert_response :bad_request
    assert get_error_detail(response, 0).include? 'full_name'

    client = Client.new
    client.full_name = 'name'
    client.phone_number = 'phone'
    input = JsonObject.new client
    post '/clients', params:input.json
    assert_response :bad_request
    assert get_error_detail(response, 0).include? 'email_address'

    client = Client.new
    client.full_name = 'name'
    client.email_address = 'email'
    input = JsonObject.new client
    post '/clients', params:input.json
    assert_response :bad_request
    assert get_error_detail(response, 0).include? 'phone_number'
  end

end
