require 'torquebox-messaging'
require 'deployer'
require 'models'

class DeployerTask < TorqueBox::Messaging::Task
  include StompBox::Config

  def deploy(payload)
    push = Push.get(payload[:id])
    if push
      Deployer.undeploy_branch(push.branch)
      Deployer.new(push).deploy
    end
  end

  def undeploy(payload)
    push = Push.get(payload[:id])
    if push
      Deployer.new(push).undeploy
    end
  end
end
