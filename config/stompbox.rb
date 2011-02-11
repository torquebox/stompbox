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


