require File.join(File.dirname(__FILE__), '..', 'stompbox.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'

set :environment, :test
set :raise_errors, true
set :logging, false

