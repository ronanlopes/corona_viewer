# config valid only for current version of Capistrano
lock "3.8.2"

set :application, 'bbaemp'
set :repo_url, 'git@github.com:fneto/bba_emp_web.git'
set :user, 'ubuntu'


# Need this so capistrano creates the directories as "ubuntu" user
set :use_sudo, false

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/ubuntu/bbaemp'

set :passenger_restart_with_touch, true

set :rvm_type, :user
set :rvm_ruby_version, '2.3.1'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :linked_files, %w{config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end