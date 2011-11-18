#
# Copyright 2011 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ENV['REQUIRE_AUTHENTICATION'] = 'true'
ENV['RACK_ENV'] = 'test'

#require 'spec_helper'
      
#module StompBox 

  #describe 'application with authentication' do

    #it "should redirect to login if credentials are not supplied" do
      #get '/'
      #last_response.should be_redirect
    #end

    #it "should redirect to login if credentials are incorrect" do
      #authenticator = Object.new
      #TorqueBox::Authentication.stub!(:default).and_return(authenticator)
      #authenticator.stub!(:authenticate).and_return(false)
      #post '/login', {:user=>:foo, :password=>:bar}
      #last_response.should be_redirect
    #end

    #it "should allow access when authorized" do
      #rack_mock_session.stub!('authenticated?').and_return(true)
      #get "/"
##      last_response.should be_ok
      #puts "TODO: This test is incorrect"
    #end

  #end

#end


