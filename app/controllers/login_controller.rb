class LoginController < ApplicationController

  http_basic_authenticate_with name: Rails.configuration.username,
    password: Rails.configuration.password

  def index
  end

end
