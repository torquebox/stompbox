require 'dm-core'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, "postgres://stompbox:stompbox@localhost/stompbox")
DataMapper.finalize

module StompBox
  module Config
    def self.get(property)
      @@config ||= YAML::load(File.open("config/stompbox.yml"))
      @@config[property]
    end
  end
end
