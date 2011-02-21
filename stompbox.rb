$: << File.join(File.dirname(__FILE__), 'app')
$: << File.join(File.dirname(__FILE__), 'app', 'models')

require 'rubygems'

require 'sinatra/base'

require 'haml'
require 'sass'
require 'yaml'
require 'rack-flash'

require 'config/stompbox'
require 'authentication'
require 'deployer'
require 'models'

class Stompbox < Sinatra::Base
  enable :sessions, :logging, :method_override
  set :views, Proc.new { File.join(File.dirname(root), "app", "views") }
  use Rack::Flash
  
  helpers do
    include StompBox::Config
    include Sinatra::Authentication

    def config(key)
      StompBox::Config.get(key)
    end

    def home_path
      request.script_name
    end

    def path_to(location)
      "#{home_path}/#{location}"
    end

    def redirect_to(location)
      redirect path_to(location)
    end

    def repositories
      @repositories ||= Repository.ordered
    end

    def classes_for(push)
      track = push.tracked? ? 'tracked' : 'ignored'
      [push.status, track, classify(push.repo_name), classify(push.branch)]
    end

    def selector_for(push)
      classes_for(push).join('.')
    end

    def classify(str)
      str.gsub('.', '-')
    end
  
  end
  
  before do
    require_authentication
  end
  
  post '/deploy' do
    if (params[:id] && (push = Push.get(params[:id])))
      Deployer.deploy(push)
    end
    redirect home_path
  end
  
  post '/undeploy' do
    if (params[:id] && (push = Push.get(params[:id])))
      Deployer.undeploy(push)
    end
    redirect home_path
  end
  
  # Post a deployment
  post '/push/:api_key' do
    puts params[:payload].inspect
    if params[:payload] && (params[:api_key] == config('api_key'))
      push = Push.create(:payload=>params[:payload], :created_at=>Time.now)
      push.save if push
    end
    redirect home_path
  end
  
  # List all deployments
  get '/' do
    @pushes = Push.all(:order => [ :created_at.desc ])
    haml :'pushes/index'
  end
  
  get '/repositories' do
    repositories 
    haml :'repositories/index'
  end
  
  post '/repositories' do
    if params[:repository]
      repo = Repository.create(params[:repository])
      flash[:error] = repo.errors unless repo.save
    end
    redirect_to "repositories"
  end

  delete '/repositories/:id' do
    if repo = Repository.get(params[:id])
      repo.destroy 
    end
    redirect_to "repositories"
  end
  
  put '/repositories/:id' do
    if repo = Repository.get(params[:id])
      repo.update(params[:repository])
      repo.save
    end
    redirect_to "repositories"
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
