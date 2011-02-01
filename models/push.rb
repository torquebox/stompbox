require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "postgres://stompbox:stompbox@localhost/stompbox")

class Push
  include DataMapper::Resource

  property :id,         Serial
  property :payload,    Text, :required => true
  property :created_at, DateTime
end

DataMapper.auto_upgrade!

