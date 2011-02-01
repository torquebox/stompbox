require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

require 'models/push'

post '/' do
  if params[:payload]
    push = Push.create(:payload=>params[:payload], :created_at=>Time.now)
    push.save if push
  end
  redirect '/'
end

get '/' do
  @pushes = Push.all
  haml :index
end
