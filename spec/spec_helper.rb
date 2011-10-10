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

require 'java'
require 'torquebox-cache'
require 'rack/test'
require 'stompbox'

# set test environment
Sinatra::Base.set :environment, :test
Sinatra::Base.set :run, false
Sinatra::Base.set :raise_errors, true
Sinatra::Base.set :logging, false

DataMapper.setup(:default, :adapter=>'infinispan')

def app
  @app ||= StompBox::Application.new
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  # reset database before each example is run
  conf.before(:each) { DataMapper.auto_migrate! }
end


