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
  describe Deployer do

    ENV['TORQUEBOX_HOME'] = './.apps'

    it "should write a YAML file" do
      config = { 
        'environment' => { 'oauth_key' => '123456789', 'oauth_secret' => '987654321' } 
      }
      repo = Repository.create(:name=>'github', :branch=>'master', :config=>config)
      push = Push.new(:payload=>payload)
      push.stub!(:find_repository).and_return(repo)
      deployer = Deployer.new(push)
      deployer.write_descriptor
    end

    it "should fail gracefully if the repository can't be found" do
      config = { 
        'environment' => { 'oauth_key' => '123456789', 'oauth_secret' => '987654321' } 
      }
      push = Push.new(:payload=>payload)
      deployer = Deployer.new(push)
      deployer.write_descriptor.should be_false
    end
  end

  
end


def payload
<<END
    {"before": "5aef35982fb2d34e9d9d4502f6ede1072793222d",
        "repository": {
          "url": "http://github.com/defunkt/github",
          "name": "github",
          "description": "You are looking at it.",
          "watchers": "5",
          "forks": "2",
          "private": "1",
          "owner": {
            "email": "chris@ozmm.org",
            "name": "defunkt"
          }
        },

        "commits": [
          {
            "id": "41a212ee83ca127e3c8cf465891ab7216a705f59",
            "url": "http://github.com/defunkt/github/commit/41a212ee83ca127e3c8cf465891ab7216a705f59",
            "author": {
              "email": "chris@ozmm.org",
              "name": "Chris Wanstrath"
            },
            "message": "okay i give in",
            "timestamp": "2008-02-15T14:57:17-08:00",
            "added": ["filepath.rb"]
          },
          {
            "id": "de8251ff97ee194a289832576287d6f8ad74e3d0",
            "url": "http://github.com/defunkt/github/commit/de8251ff97ee194a289832576287d6f8ad74e3d0",
            "author": {
              "email": "chris@ozmm.org",
              "name": "Chris Wanstrath"
            },
            "message": "update pricing a tad",
            "timestamp": "2008-02-15T14:36:34-08:00"
          }
        ],
        "after": "de8251ff97ee194a289832576287d6f8ad74e3d0",
        "ref": "refs/heads/master"
      }
END
end
