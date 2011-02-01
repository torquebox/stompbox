require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'yaml'

require 'models/push'

helpers do
  def status(push)
    if (repositories.has_key? push['repository']['name'])
      "Pending"
    else
      "This repository will NOT be deployed"
    end
  end

  def repositories
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
