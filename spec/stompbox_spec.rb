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

require 'spec_helper'

module StompBox 

  describe 'routes' do

    before(:each) do
      app.stub!(:require_authentication).and_return(true)
    end

    it "should respond to GET /"# do
#      get '/'
#      last_response.should be_ok
#    end

    it "should respond to GET /repositories" #do
#      get '/repositories'
#      last_response.should be_ok
#    end

    it "should respond to POST /repositories" do
      post '/repositories'
      last_response.should be_redirect
    end

    it "should respond to PUT /repositories" do
      put '/repositories/1'
      last_response.should be_redirect
    end

    it "should respond to DELETE /repositories/:id" do
      delete '/repositories/1'
      last_response.should be_redirect
    end
      
  end

end
