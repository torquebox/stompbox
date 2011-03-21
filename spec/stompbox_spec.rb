require 'spec_helper'

module StompBox 

  describe 'application with Authentication' do
    before(:each) do
      ENV['REQUIRE_AUTHENTICATION'] = 'true'
    end

    it "should redirect to login if credentials are not supplied" do
      ENV['REQUIRE_AUTHENTICATION'] = 'true'
      get '/stompbox'
      last_response.status.should == 302
    end
  end

end
