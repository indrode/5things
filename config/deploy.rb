#############################################################
# This file is designed as a starting point to use
# capistrano to deploy the trunk of tracks to a webhost
# where it is served using Phusion Passenger. For more
# info on getting started with Passenger, see
# http://www.modrails.com/
#############################################################


#############################################################
# Application
#############################################################

set :application, "muma"
set :deploy_to, "/home/zorro/staging"
set :database_conf, "/home/zorro/database_conf" #contains database.yml.production

#############################################################
# Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :scm_verbose, true
set :rails_env, "production"

#############################################################
# Servers
#############################################################

set :user, "zorro"
set :port, 52520
set :domain, "testing.5things.com"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
# Git
#############################################################

set :scm, :git
set :branch, "master"
set :repository, "git@github.com:indrode/zenpunch.git"
set :deploy_via, :remote_cache

#############################################################
# Passenger
#############################################################

namespace :deploy do
 
 # restart passenger, install gems
 desc "Restarting mod_rails with restart.txt"
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "cd #{current_path} && bundle install"
   run "touch #{current_path}/tmp/restart.txt"
   # start/restart sphinx manually as root/sudoer
 end

 [:start, :stop].each do |t|
   desc "#{t} task is a no-op with mod_rails"
   task t, :roles => :app do ; end
 end

end

# Task to copy production db config after deployment
task :after_update_code, :roles => :app do  
  db_config = "#{database_conf}/database_#{application}.yml.production"
    run "cp #{db_config} #{release_path}/config/database.yml"
end
