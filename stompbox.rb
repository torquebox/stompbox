require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'yaml'

require 'config/stompbox'
require 'deployer'
require 'models'

include StompBox::Config

helpers do
  def config(key)
    StompBox::Config.get(key)
  end

end

post '/deploy' do
  if (params[:id] && (push = Push.get(params[:id])))
    Deployer.deploy(push)
  end
  redirect request.script_name
end

post '/undeploy' do
  if (params[:id] && (push = Push.get(params[:id])))
    Deployer.undeploy(push)
  end
  redirect request.script_name
end

# Post a deployment
post '/:api_key' do
  if params[:payload] && (params[:api_key] == config('api_key'))
    push = Push.create(:payload=>params[:payload], :created_at=>Time.now)
    push.save if push
  end
  redirect request.script_name
end

# List all deployments
get '/' do
  @pushes = Push.all(:order => [ :created_at.desc ])
  haml :index
end

# Stylesheets - reset
get '/html5reset.css' do
  sass :html5reset
end

# App stylesheet
get '/styles.css' do
  scss :styles
end
