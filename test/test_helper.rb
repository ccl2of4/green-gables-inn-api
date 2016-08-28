ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def get_json(json)
    if json.is_a? JsonObject
      json = json.json
    end
    if json.is_a? ActionDispatch::TestResponse
      json = response.body
    end
    if json.is_a? String
      json = JSON.parse(json)
    end
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

end
