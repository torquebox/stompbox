require 'git'
require 'open3'
require 'models'
require 'config/stompbox'
require 'torquebox/rake/tasks'

class Deployer

  attr_accessor :push

  def initialize(push)
    @push = push
  end

  def self.deploy(push)
    Deployer.undeploy_branch(push.branch)
    Deployer.new(push).deploy
  end

  def self.undeploy(push)
    Deployer.new(push).undeploy
  end

  def self.undeploy_branch(branch)
    Deployment.all(:branch=>branch).each do |d|
      Deployer.undeploy(d.push)
    end
  end

  def undeploy
    push.undeploy
    TorqueBox::RakeUtils.undeploy( repository_name )
    remove_repo if ( File.exist?( root ) )
    push.undeployed
  end


  # This is the async method
  # Add tcrawley bg stuff here
  def deploy
    begin
      push.deploy
      clone_repo
      freeze_gems
      write_descriptor
      push.deployed
      d = Deployment.create(
        :created_at=>Time.now, 
        :push=>push,
        :branch=>push.branch,
        :path=>deployment_path,
        :context=>"/#{repository_name}")
      d.save!
      push.save
      puts "Deploy complete"
    rescue Exception => ex
      puts ex
      push.failed
    end
  end

  # Hack to avoid problems with github responses using git gem over https
  def git_url
    push.repo_url.sub('https', 'git')
  end

  def deployment_path
    StompBox::Config.get('deployments')
  end

  def repository_name
    @repo_name ||= push.master? ? push.repo_name : "#{push.repo_name}-#{push.branch}"
  end

  def root
    "#{deployment_path}/#{repository_name}"
  end

  protected

  def remove_repo
    puts "Removing #{repository_name}"
    FileUtils.rm_rf( root )
  end

  def clone_repo
    remove_repo if ( File.exist?( root ) )
    puts "Cloning #{git_url} to #{root}"
    git = Git.clone(git_url, repository_name, :path=>deployment_path)
    puts "Resetting repo to #{push['after']}"
    git.reset_hard(push['after'])
  end

  def freeze_gems
    puts "Freezing gems"
    if ( File.exist?( path_to('Gemfile') ) )
      jruby = File.join( RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'] )
      exec_cmd( "cd #{root} && #{jruby} -S bundle package" )
      exec_cmd( "cd #{root} && #{jruby} -S bundle install --local --path vendor/bundle" )
    end
  end

  def write_descriptor
    name, descriptor = deployment( repository_name, root, repository_name )
    TorqueBox::RakeUtils.deploy_yaml( name, descriptor )
  end

  def path_to(file)
    "#{root}/#{file}"
  end

  def exec_cmd(cmd)
    Open3.popen3( cmd ) do |stdin, stdout, stderr|
      stdin.close
      stdout_thr = Thread.new(stdout) {|stdout_io|
        stdout_io.each_line do |l|
          STDOUT.puts l
          STDOUT.flush
        end
        stdout_io.close
      }
      stderr_thr = Thread.new(stderr) {|stderr_io|
        stderr_io.each_line do |l|
          STDERR.puts l
          STDERR.flush
        end
      }
      stdout_thr.join
      stderr_thr.join
    end
  end
end




