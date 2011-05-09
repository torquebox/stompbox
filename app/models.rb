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

require 'json'
require 'state_machine'
require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-types'

class Push
  include DataMapper::Resource

  property :id,         Serial
  property :status,     String
  property :payload,    Text, :required => true, :lazy => false
  property :created_at, DateTime

  has 1, :deployment

  attr_accessor :parsed_payload

  state_machine :status, :initial => :received do

    event :deploy do
      transition all - [:deploying, :deployed] => :deploying
    end

    event :deployed do
      transition :deploying => :deployed
    end

    event :failed do
      transition all => :failed
    end

    event :undeploy do
      transition :deployed => :undeploying
    end

    event :undeployed do
      transition all => :undeployed
    end

    after_transition all => :undeploying do 
      self.deployment.destroy unless self.deployment.nil?
    end

  end

  def tracked?
    Repository.ordered.any? { |r| r.name == repo_name && r.branch == branch }
  end

  def [](property)
    parse_payload[property]
  end

  def repo_url
    self['repository']['url']
  end

  def repo_name
    self['repository']['name']
  end

  def branch
    self['ref'].split('/').last
  end

  def master?
    branch == 'master'
  end

  def short_commit_hash
    self['after'][0..6]
  end

  def self.deployed
    Push.all(:status=>:deployed)
  end

  def find_repository
    Repository.first(:name=>repo_name, :branch=>branch)
  end

  protected
  def parse_payload
    @parsed_payload ||= JSON.parse(self.payload)
  end

end

class Deployment
  include DataMapper::Resource

  property :id, Serial
  property :path, String
  property :context, String
  property :branch, String
  property :created_at, DateTime

  belongs_to :push

end

class Repository
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :branch, String
  property :config, Yaml

  def self.ordered
    Repository.all(:order => [:name, :branch])
  end

end

class DeploymentFile
  include DataMapper::Resource

  property :id, Serial
  property :path, String
  property :body, Text

  belongs_to :repository

end

database_url = ENV['DATABASE_URL']
database_url ||= 'postgres://stompbox:stompbox@localhost/stompbox'

DataMapper::Logger.new($stdout, :info)
DataMapper.setup(:default, database_url)
DataMapper::Model.raise_on_save_failure = true 
DataMapper.finalize


if ENV['AUTO_MIGRATE']
  DataMapper.auto_upgrade!
end
