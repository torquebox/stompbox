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

  state_machine :initial => :received do

    event :deploy do
      # If any pushes are already deployed, undeploy them
      # Git the push
      # torquebox:archive & deploy
      # Write deployment date
      transition all - :deployed => :deployed
    end

    event :undeploy do
      # Write undeployment date
      transition :deployed => :undeployed
    end

  end

  attr_accessor :parsed_payload

  def [](property)
    parse[property]
  end

  protected
  def parse
    @parsed_payload ||= JSON.parse(self.payload)
  end
end

DataMapper.auto_upgrade!


