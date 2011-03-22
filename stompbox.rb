#
# Copyright 2011 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$: << File.join(File.dirname(__FILE__), 'app')

require 'rubygems'
require 'sinatra/base'
require 'rack-flash'

require 'haml'
require 'sass'
require 'yaml'

require 'config/stompbox'
require 'authentication'
require 'deployer'
require 'helpers'
require 'models'


module StompBox
  class Application < Sinatra::Base 
    include StompBox::Authentication
    use Rack::Flash 


    enable :sessions, :logging, :method_override 
    set :root, Proc.new { File.expand_path(File.dirname(__FILE__)) }
    set :views, Proc.new { File.join(File.dirname(__FILE__), "app", "views") } 
    
  
    if ENV['REQUIRE_AUTHENTICATION']
      ['*/push/*','*/login','*/logout', '*.js', '/*.css' ].each do |p|
        before p do 
          skip_authentication 
        end
      end
      
      before do 
        require_authentication 
      end
    else
      puts "ENV['REQUIRE_AUTHENTICATION'] is not set, *disabling* authentication" if ENV['REQUIRE_AUTHENTICATION'].nil?
    end
  
    post '/deploy' do
      if (params[:id] && (push = Push.get(params[:id])))
        Deployer.deploy(push)
      end
      redirect to('/')
    end
    
    post '/undeploy' do
      if (params[:id] && (push = Push.get(params[:id])))
        Deployer.undeploy(push)
      end
      redirect to('/')
    end
    
    # Post a deployment
    post '/push/:api_key' do
      if params[:payload] && (params[:api_key] == config('api_key'))
        push = Push.create(:payload=>params[:payload], :created_at=>Time.now)
        push.save if push
      end
      redirect to('/')
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
      redirect to("/repositories")
    end
  
    delete '/repositories/:id' do
      if repo = Repository.get(params[:id])
        repo.destroy 
      end
      redirect to("/repositories")
    end
    
    put '/repositories/:id' do
      if repo = Repository.get(params[:id])
        repo.update(params[:repository])
        repo.save
      end
      redirect to("repositories")
    end
    
    # Stylesheets - reset
    get '/html5reset.css' do
      sass :html5reset
    end
    
    # App stylesheet
    get '/styles.css' do
      scss :styles
    end
  
    get '/login' do
      haml :'sessions/new'
    end
  
    post '/login' do
      flash[:notice] = "Bad credentials. Try again?" unless authenticate( params[:user], params[:password] )
      redirect to('/')
    end
  
    get '/logout' do
      logout
    end
    
    run! if app_file == $0
  end
end 
