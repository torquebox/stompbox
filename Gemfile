source :rubygems
#source 'http://rubygems.torquebox.org'
#source 'http://torquebox.org/2x/builds/LATEST/gem-repo/'


gem 'bundler'
gem 'rake'
gem "sinatra", "~>1.2.6"
gem "rack-flash", "~>0.1.1"

# odd, but this is required by monkey-lib which is required by rack session
# cookies, but doesn't get installed unless we're explicit about it
#gem "extlib" 

gem 'haml', '~>3.0'
gem 'sass', '~>3.1'
gem 'json_pure', '~>1.4.6'
gem 'state_machine'
gem 'git'

gem 'addressable', '~>2.2.6'

gem 'dm-core', '~>1.1'
gem 'dm-types', '~>1.1'
gem 'dm-migrations', '~>1.1'
gem 'dm-timestamps', '~>1.1'
gem 'dm-serializer', '~>1.1'
gem 'dm-sqlite-adapter'
gem 'sqlite3'

gem 'torquebox-security', '~> 2.0'
gem 'torquebox-messaging', '~> 2.0'
gem 'torquebox-rake-support', '~> 2.0'

group :development do
  gem 'thor'
end

group :test do
  gem 'rspec', '~> 2.5.0', :require => 'spec'
  gem 'torquespec', '~> 0.4.6'
  gem 'capybara'
  gem 'akephalos'
end
  
