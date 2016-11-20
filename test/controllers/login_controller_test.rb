require 'test_helper'

class LoginControllerTest < ActionDispatch::IntegrationTest

    test 'login' do
      get login_url
      assert_response :unauthorized

      get login_url, with_auth(username:'invalid', password:'also invalid')

      get login_url, with_auth
      assert_response :success
    end

end
