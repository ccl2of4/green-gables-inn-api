ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def with_auth(hash = Hash.new)
    username = Rails.configuration.username
    password = Rails.configuration.password
    hash.merge({headers: {'HTTP_AUTHORIZATION' =>
      "Basic #{Base64.encode64("#{username}:#{password}")}"}})
  end

  def get_json(json)
    # Input data
    if json.is_a? JsonObject
      json = json.to_json
    end
    # Output data
    if json.is_a? ActionDispatch::TestResponse
      json = response.body
    end
    # By this point, json should definitely be a String
    if json.is_a? String
      json = JSON.parse(json)
    end
    # And now it should be a hash after JSON.parse runs
    assert json.is_a? Hash
    json
  end

  def get_id(json)
    get_json(json)['data']['id']
  end

  def get_attrs(json)
    json = get_json(json)['data']['attributes']
  end

  def get_errors(json)
    get_json(json)['errors']
  end

  def get_error_detail(json, i)
    get_json(json)['errors'][i]['detail']
  end

  # Gets the Unix timestamp representation of the input string (date)
  def get_timestamp(string)
    DateTime.parse(string).to_i
  end

end
