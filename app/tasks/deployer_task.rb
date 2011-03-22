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

require 'torquebox-messaging'
require 'deployer'
require 'models'

class DeployerTask < TorqueBox::Messaging::Task

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
