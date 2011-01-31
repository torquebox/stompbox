require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

post '/' do
  @push = params[:payload].nil? ? {:message=>"Empty payload"} : params[:payload]
  haml :index
end

get '/' do
  "You only get POST, sucka"
end
