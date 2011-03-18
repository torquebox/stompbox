require 'config/stompbox'
require 'org/torquebox/auth/authentication'

module Sinatra
  module Authentication
 
    def login_path
      "#{request.script_name}/login"
    end

    def authenticated?
      !session[:user].nil?
    end
   
    def authenticate(username, password)
      return false if username.blank? || password.blank?
      authenticator = TorqueBox::Authentication.default
      authenticator.authenticate(username, password) do
        session[:user] = username
      end
    end

    def skip_authentication
      request.env['SKIP_AUTH'] = true
    end
   
    def require_authentication
      return if request.env['SKIP_AUTH']
      return if authenticated?
      redirect login_path 
    end

    def logout
      session[:user] = nil
      redirect login_path
    end
   
  end
end
