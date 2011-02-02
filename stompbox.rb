require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'yaml'

require 'models/push'

helpers do
  def config
    YAML::load(File.open("config/repositories.yml"))
  end
end

# Post a deployment
post '/' do
  if params[:payload]
    push = Push.create(:payload=>params[:payload], :created_at=>Time.now)
    push.save if push
  end
  redirect '/'
end

post '/deploy' do
  if (params[:id] && (push = Push.get(params[:id])))
    push.background_deploy
  end
  redirect '/'
end

post '/undeploy' do
  if (params[:id] && (push = Push.get(params[:id])))
    push.background_undeploy
  end
  redirect '/'
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
