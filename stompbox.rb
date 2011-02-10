$: << File.join(File.dirname(__FILE__), 'app')
$: << File.join(File.dirname(__FILE__), 'app', 'models')

require 'rubygems'

# Framework
require 'sinatra/base'

# Presentation
require 'haml'
require 'sass'
require 'yaml'

# Application
require 'config/stompbox'
require 'authentication'
require 'deployer'
require 'models'

class Stompbox < Sinatra::Base
  set :sessions, true
  set :logging, true
  set :views, Proc.new { File.join(File.dirname(root), "app", "views") }
  
  helpers do
    def config(key)
      StompBox::Config.get(key)
    end
  
    include StompBox::Config
    include Sinatra::Authentication
  end
  
  before do
    require_authentication
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
  post '/push/:api_key' do
    if params[:payload] && (params[:api_key] == config('api_key'))
      push = Push.create(:payload=>params[:payload], :created_at=>Time.now)
      push.save if push
    end
    redirect request.script_name
  end
  
  # List all deployments
  get '/' do
    @pushes = Push.all(:order => [ :created_at.desc ])
    haml :'pushes/index'
  end
  
  get '/repositories' do
    @repositories = Repository.all(:order => [:name, :branch])
    haml :'repositories/repositories'
  end
  
  post '/repositories' do
    if params[:repository]
      repo = Repository.create(params[:repository])
      repo.save
    end
    redirect "#{request.script_name}/repositories"
  end
  
  # Stylesheets - reset
  get '/html5reset.css' do
    sass :html5reset
  end
  
  # App stylesheet
  get '/styles.css' do
    scss :styles
  end

  run! if app_file == $0
end
