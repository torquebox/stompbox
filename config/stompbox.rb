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

require 'dm-core'

module StompBox
  module Config
    def self.get(property)
      @@config ||= YAML::load(File.open("config/stompbox.yml"))
      @@config[property]
    end

    def self.repositories
      StompBox::Config.get('repositories')
    end

    def self.branches(repository)
      return nil unless StompBox::Config.repositories.has_key?(repository)
      StompBox::Config.repositories[repository]['branches']
    end
  end
end

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, StompBox::Config.get('database'))
DataMapper::Model.raise_on_save_failure = true 
DataMapper.finalize


