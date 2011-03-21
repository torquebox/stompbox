require 'rack/test'
require 'stompbox'

def app
  @app ||= Sinatra::Application
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
