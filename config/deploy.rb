# frozen_string_literal: true
# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'companies_reviews'
set :repo_url, 'git@git.raisintech.com:companies_reviews/web.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, -> { "/home/#{fetch(:application)}/app" }

# bundle install configuration
set :bundle_jobs, '2'
set :bundle_without, %w(development test ci).join(' ')
set :bundle_binstubs, -> { shared_path.join('bin') }

set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }

# Default value for :scm is :git
set :scm, :git
set :git_strategy, Capistrano::Git::SubmoduleStrategy
set :git_keep_meta, true

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, '.env'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/uploads', 'bundle', 'public/system'

# Default value for default_env is {}
set :default_env, path: "/opt/ruby/bin:#{fetch(:bundle_binstubs)}:~/.gem/ruby/2.3.0/bin:$PATH"

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  before :starting, 'maintenance:enable'

  task :start do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        # TODO. setup dotenv
        # now you need to launch 'by hands'
        execute :bundle, :exec, 'rails server'
      end
    end
  end

  task :restart do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        # TODO. use restart.txt when it will fix.
        # https://github.com/rails/rails/issues/25751
        # execute :touch, 'tmp/restart.txt'
        execute :bundle, :exec, 'pumactl restart'
      end
    end
  end

  after :publishing, :restart

  after :finished, 'maintenance:disable'
end
