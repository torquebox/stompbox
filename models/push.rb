require 'json'
require 'state_machine'
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "postgres://stompbox:stompbox@localhost/stompbox")

class Push
  include DataMapper::Resource

  property :id,         Serial
  property :status,     String
  property :payload,    Text, :required => true, :lazy => false
  property :created_at, DateTime

  attr_accessor :parsed_payload

  state_machine :status, :initial => :received do

    event :deploy do
      transition all - [:deploying, :deployed] => :deploying
    end

    before_transition :on => :deploy do 
      Push.undeploy_everything
    end

    event :deployed do
      transition :deploying => :deployed
    end

    event :failed do
      transition all => :failed
    end

    event :undeploy do
      transition :deployed => :undeployed
    end

  end

  def [](property)
    parse[property]
  end

  def repository_name
    self['repository']['name']
  end

  def self.deployed
    Push.all(:status=>:deployed)
  end

  protected
  def parse
    @parsed_payload ||= JSON.parse(self.payload)
  end

  def self.undeploy_everything
    Push.deployed.each do |p|
      p.undeploy
    end
  end

end

DataMapper.auto_upgrade!


