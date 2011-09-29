source :rubygems
#source 'http://rubygems.torquebox.org'
source 'http://torquebox.org/2x/builds/LATEST/gem-repo/'


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

#gem 'data_mapper', '~>1.1'
gem 'dm-core', '~>1.1'
gem 'dm-types', '~>1.1'
gem 'dm-migrations', '~>1.1'
gem 'dm-timestamps', '~>1.1'
gem 'dm-serializer', '~>1.1'

gem 'torquebox-rake-support', '~> 2.x.incremental'
gem 'torquebox-security', '~> 2.x.incremental'
gem 'torquebox-cache', '~> 2.x.incremental'

group :development do
  gem 'thor'
end

group :test do
  gem 'rspec', '~> 2.5.0', :require => 'spec'
  gem 'rack-test'
  gem 'sqlite3'
  gem 'dm-sqlite-adapter'
  gem 'torquespec'
  gem 'capybara'
  gem 'akephalos'
end
  
