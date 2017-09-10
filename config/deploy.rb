# config valid only for current version of Capistrano
lock "3.9.1"

set :application, "mecab_api"
set :repo_url, "https://github.com/thr3a/mecab_api_sinatra.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :puma_threads,    [4, 16]
set :puma_workers,    0
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{shared_path}/log/puma.error.log"
set :puma_error_log,  "#{shared_path}/log/puma.access.log"

namespace :deploy do

  task :mkdir do
    on roles(:all), in: :sequence, wait: 5 do
      execute :sudo, :mkdir, '-p', "#{fetch(:deploy_to)}"
      execute :sudo, :chown, "#{fetch(:user)}:#{fetch(:user)}", "#{fetch(:deploy_to)}"
    end
  end

  task :upload do
    on roles(:all), in: :sequence, wait: 5 do
      fetch(:linked_files).each do |filename|
        execute :mkdir, '-p', "#{shared_path}/#{File.dirname(filename)}"
        upload!(filename, "#{shared_path}/#{filename}")
      end
    end
  end
  
end