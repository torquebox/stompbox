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

  state_machine :status, :initial => :received do

    event :deploy do
      # If any pushes are already deployed, undeploy them
      # Git the push
      # torquebox:archive & deploy
      # Write deployment date
      transition all - :deployed => :deploying
    end

    event :deployed do
      transition :deploying => :deployed
    end

    event :failed do
      transition :deploying => :failed
    end

    event :undeploy do
      # Write undeployment date
      transition :deployed => :undeploying
    end

    event :undeployed do
      transition :undeploying => :undeployed
    end

  end

  attr_accessor :parsed_payload

  def [](property)
    parse[property]
  end

  def initialize
    super() # required by state_machine
  end

  # Use tcrawley's background stuff
  def background_deploy
    self.deploy
    self.deployed
  end

  # Use tcrawley's background stuff
  def background_undeploy
    self.undeploy!
    self.undeployed!
  end

  protected
  def parse
    @parsed_payload ||= JSON.parse(self.payload)
  end

end

DataMapper.auto_upgrade!


