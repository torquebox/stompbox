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
