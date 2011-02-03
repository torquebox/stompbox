module StompBox
  module Config
    def self.get(property)
      @@config ||= YAML::load(File.open("config/stompbox.yml"))
      @@config[property]
    end
  end
end
