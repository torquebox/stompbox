require 'integration_spec/spec_helper'

describe 'a basic test' do
  
  deploy <<-END.gsub( /^ {4}/, '' )
    application:
      root: #{File.dirname( __FILE__ )}/..
    env: 
      RACK_ENV: test
      REQUIRE_AUTHENTICATION: false
    web:
      context: /stompbox-test
    ruby:
      version: #{RUBY_VERSION[0,3]}
  END

  it "should work" do
    visit "/stompbox-test"
    puts page.body
    page.should have_content( 'Dashboard' )
  end
end

