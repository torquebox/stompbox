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
    Deployer.new(push).deploy
  end

  def self.undeploy(push)
    Deployer.new(push).undeploy
  end

  # Async
  def undeploy
    push.undeploy
    remove_repo
    if push.deployment
      push.deployment.undeployed_at = Time.now
      push.deployment.save
    end
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
        :path=>deployment_path,
        :context=>"/#{repository_name}")
      d.save!
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
    "#{push.repo_name}-#{push.short_commit_hash}"
  end

  def root
    "#{deployment_path}/#{repository_name}"
  end

  protected

  def remove_repo
    puts "Removing #{repository_name}"
    TorqueBox::RakeUtils.undeploy( push.repo_name )
    FileUtils.rm_rf( repository_name )
  end

  def clone_repo
    puts "Cloning #{git_url} to #{repository_name}"
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
    deployment_name, deployment_descriptor = deployment( push.repo_name, root, repository_name)
    TorqueBox::RakeUtils.deploy_yaml( deployment_name, deployment_descriptor )
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




