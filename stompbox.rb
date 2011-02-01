require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'

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


# Stylesheets
get '/html5reset.css' do
  sass :html5reset
end

get '/styles.css' do
  scss :styles
end
