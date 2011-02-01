require 'json'
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "postgres://stompbox:stompbox@localhost/stompbox")

class Push
  include DataMapper::Resource

  property :id,         Serial
  property :payload,    Text, :required => true, :lazy => false
  property :created_at, DateTime

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

