require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

get '/' do
  @push = params[:payload].nil? ? {:message=>"Empty payload"} : params[:payload]
  haml :index
end
