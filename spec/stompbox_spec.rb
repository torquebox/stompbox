require File.dirname(__FILE__) + '/spec_helper'

describe "StompBox" do
  include Rack::Test::Methods

  def app
    @app ||= Sinatra::Application
  end

  it "should respond with attitude to GET /" do
    get '/'
    last_response.body.should == 'You only get POST, sucka'
  end

  it "should respond to POST /" do
    post '/'
    last_response.should be_ok
  end
end
