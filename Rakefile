require 'torquebox/rake/tasks'

SERVER_ROOT = "#{ENV['JBOSS_HOME']}/server/default" 

desc "Touch the deployment descriptor"
task 'redeploy' do
  sh "touch #{server_root}/deploy/stompbox-knob.yml"
end

desc "Set the admin user. Provide username and password as 'rake set_admin CREDENTIALS=user:pass'. If no credentials are supplied, defaults to admin:admin"
task :set_admin do
  admin = ENV['CREDENTIALS'] || 'admin:admin'
  admin.gsub!(/:/, '=')
  sh "echo #{admin} >> #{SERVER_ROOT}/conf/defaultUsers.properties"
  sh "touch #{SERVER_ROOT}/conf/defaultRoles.properties"
end

