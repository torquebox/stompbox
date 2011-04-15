require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'torquebox-rake-support'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "torquebox-stompbox"
  gem.homepage = "http://github.com/torquebox/stompbox"
  gem.license = "MIT"
  gem.summary = %Q{StompBox - Git-based deployment console for TorqueBox}
  gem.description = %Q{StompBox - Git-based deployment console for TorqueBox}
  gem.email = "lball@redhat.com"
  gem.authors = ["Lance Ball"]
  gem.files = FileList["[A-Z]*.*", 'stompbox.rb', 'config.ru', 'bin/*', "{app, config, javascript, public}/**/*"]
  gem.executables = %w{stompbox}
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency 'thor', '> 0.14'
  gem.add_runtime_dependency 'bundler', '>= 1.0.12'
  gem.add_runtime_dependency 'torquebox-rake-support'
end
Jeweler::RubygemsDotOrgTasks.new


