require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina_sidekiq/tasks'
require 'mina/unicorn'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :deploy_to, '/home/deployer/social/'
set :repository, 'git@github.com:AlexBeznos/social.git'
set :user, 'deployer'
set :forward_agent, true
set :port, '22'
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
set :rvm_path, '/usr/local/rvm/scripts/rvm'
set :shared_paths, ['config/database.yml', 'log', 'config/secrets.yml', 'config/application.yml']

task :environment do
  queue %{echo "-----> Loading environment"}
  invoke :'rvm:use[ruby-2.1.3@social]'
end

task :basic_setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  queue %[echo "-----> Be sure to edit 'shared/config/secrets.yml'."]

  # sidekiq needs a place to store its pid file and log file
  queue! %[mkdir -p "#{deploy_to}/shared/pids/"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/pids"]
end

task :basic_logs do
  queue "tail -f social/#{ENV['releas'] ||= 'current'}/log/production.log --lines=#{ENV['lines'] ||= '100'}"
end

task :basic_deploy => :environment do
  deploy do
    # stop accepting new workers
    invoke :'sidekiq:quiet'

    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:assets_precompile'
    invoke :'rails:db_migrate'

    queue 'mkdir public/settings && chmod 755 public/settings'
    queue 'mkdir public/vk && chmod 755 public/vk'

    to :launch do
      invoke :'sidekiq:restart'
      invoke :'unicorn:restart'
    end
  end
end

task :cleanup do
    queue %{
      echo "-----> Cleaning up old releases (keeping #{keep_releases!})"
      #{echo_cmd %{cd "#{deploy_to!}/#{releases_path!}" || exit 15}}
      #{echo_cmd %{count=`ls -1d [0-9]* | sort -rn | wc -l`}}
      #{echo_cmd %{remove=$((count > #{keep_releases} ? count - #{keep_releases} : 0))}}
      #{echo_cmd %{ls -1d [0-9]* | sort -rn | tail -n $remove | xargs rm -rf {}}}
    }
  end

# namespace :stage do
#   task :set_domain do
#     set :domain, 'stage.gofriends.com.ua'
#   end

#   task :setup do
#     invoke :'stage:set_domain'
#     invoke :basic_setup
#   end

#   task :logs do
#     invoke :'stage:set_domain'
#     invoke :basic_logs
#   end

#   task :deploy do
#     set :branch, 'stage'
#     invoke :'stage:set_domain'
#     invoke :basic_deploy
#   end

#   task :cleanup do
#     invoke :'stage:set_domain'
#     invoke :cleanup
#   end
# end

# namespace :app_1 do
#   task :set_domain do
#     set :domain, '138.197.187.19'
#   end

#   task :setup do
#     invoke :'app_1:set_domain'
#     invoke :basic_setup
#   end

#   task :logs do
#     invoke :'app_1:set_domain'
#     invoke :basic_logs
#   end

#   task :deploy do
#     invoke :'app_1:set_domain'
#     invoke :basic_deploy
#   end

#   task :cleanup do
#     invoke :'app_1:set_domain'
#     invoke :cleanup
#   end
# end

# namespace :app_2 do
#   task :set_domain do
#     set :domain, 'app-2.gofriends.com.ua'
#   end
#   task :setup do
#     invoke :'app_2:set_domain'
#     invoke :basic_setup
#   end

#   task :logs do
#     invoke :'app_2:set_domain'
#     invoke :basic_logs
#   end

#   task :deploy do
#     invoke :'app_1:set_domain'
#     invoke :basic_deploy
#   end

#   task :cleanup do
#     invoke :'app_1:set_domain'
#     invoke :cleanup
#   end
# end

namespace :prod do
  set :domains, %w[138.197.187.19]

  task :logs do
    isolate do
      domains.each do |domain|
        set :domain, domain
        queue %[echo "-----> Server #{domain} logs."]
        invoke :basic_logs
        run!
      end
    end
  end

  task :deploy do
    isolate do
      domains.each_with_index do |domain, index|
        set :domain, domain
        invoke :basic_deploy
        run!
      end
    end
  end

  task :cleanup do
    isolate do
      domains.each_with_index do |domain, index|
        set :domain, domain
        invoke :cleanup
        run!
      end
    end
  end
end
