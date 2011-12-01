require 'torquespec'
require 'fileutils'
require 'torquebox-rake-support'
require 'capybara/dsl'
require 'akephalos'


# Because DRb requires ObjectSpace and 1.9 disables it
require 'jruby'
JRuby.objectspace = true


TorqueSpec.knob_root = File.join( File.dirname( __FILE__ ), '.integ-knobs' )
FileUtils.mkdir_p(TorqueSpec.knob_root) unless File.exist?(TorqueSpec.knob_root)

Capybara.register_driver :akephalos do |app|
  Capybara::Driver::Akephalos.new(app, :browser => :firefox_3, :validate_scripts => false)
end

Capybara.default_driver = :akephalos
Capybara.app_host = "http://localhost:8080"
Capybara.run_server = false

RSpec.configure do |config|
  config.include Capybara
  config.after do
    Capybara.reset_sessions!
  end
end


TorqueSpec.configure do |config|
  config.max_heap = java.lang::System.getProperty( 'max.heap' )
  config.lazy = java.lang::System.getProperty( 'jboss.lazy' ) == "true"
  config.jvm_args += " -Dgem.path=default"
end

