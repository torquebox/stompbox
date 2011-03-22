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

module StompBox
  class Application < Sinatra::Base 
    
    helpers do 
  
      def config(key)
        ENV[key]
      end
  
      def home_path
        request.script_name
      end
  
      def to(location)
        location.gsub!(/^\//, '')
        "#{home_path}/#{location}"
      end
  
      def repositories
        @repositories ||= Repository.ordered
      end
  
      def classes_for(push)
        track = push.tracked? ? 'tracked' : 'ignored'
        [push.status, track, classify(push.repo_name), classify(push.branch)]
      end
  
      def selector_for(push)
        classes_for(push).join('.')
      end
  
      def classify(str)
        str.gsub('.', '-')
      end
  
    end
  end
end
