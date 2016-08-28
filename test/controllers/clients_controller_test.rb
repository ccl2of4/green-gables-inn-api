require 'test_helper'

class ClientsControllerTest < ActionDispatch::IntegrationTest

  test 'get clients' do
    get '/clients'
    assert_response :success
    json = JSON.parse(response.body)
    assert json['data'].length == 2
  end

  test 'check attributes' do
    get '/clients'
    json = JSON.parse(response.body)
    attrs = json['data'][0]['attributes']
    assert_not_nil attrs['full_name']
    assert_not_nil attrs['email_address']
    assert_not_nil attrs['phone_number']
    assert_not_nil attrs['created_at']
    assert_not_nil attrs['updated_at']
    assert attrs.size == 5
  end

  test 'get client' do
    get '/clients'
    id = JSON.parse(response.body)['data'][0]['id']

    get "/clients/#{id}"
    assert_response :success
    json = JSON.parse(response.body)
    assert json['data']['id'] == id
  end

  test 'create client' do
    client = Client.new
    client.full_name = 'name'
    client.email_address = 'email'
    client.phone_number = 'phone'
    input = JsonObject.new client
    post '/clients', params:input.json
    assert_response :success
    output = JSON.parse(response.body)
    assert output['data'].kind_of? Hash
    assert output['data']['attributes'].kind_of? Hash
    assert_not_nil output['data']['id']
    assert output['data']['attributes']['name'] == input.json['data']['attributes']['name']
    assert output['data']['attributes']['email_address'] == input.json['data']['attributes']['email_address']
    assert output['data']['attributes']['phone_number'] == input.json['data']['attributes']['phone_number']
  end

  test 'required attributes for create client' do
    client = Client.new
    client.email_address = 'email'
    client.phone_number = 'phone'
    input = JsonObject.new client
    post '/clients', params:input.json
    assert_response :bad_request
    output = JSON.parse(response.body)
    assert output['errors'][0]['detail'].include? 'full_name'

    client = Client.new
    client.full_name = 'name'
    client.phone_number = 'phone'
    input = JsonObject.new client
    post '/clients', params:input.json
    assert_response :bad_request
    output = JSON.parse(response.body)
    assert output['errors'][0]['detail'].include? 'email_address'

    client = Client.new
    client.full_name = 'name'
    client.email_address = 'email'
    input = JsonObject.new client
    post '/clients', params:input.json
    assert_response :bad_request
    output = JSON.parse(response.body)
    assert output['errors'][0]['detail'].include? 'phone_number'
  end

end
