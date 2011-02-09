require 'json'
require 'state_machine'
require 'dm-migrations'
require 'dm-timestamps'

require 'config/stompbox'

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
    StompBox::Config.repositories.keys.include?(repo_name) && 
    StompBox::Config.branches(repo_name).include?(branch)
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

end

class DeploymentFile
  include DataMapper::Resource

  property :id, Serial
  property :path, String
  property :body, Text

  belongs_to :repository

end


DataMapper.auto_upgrade!

