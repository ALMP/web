# frozen_string_literal: true
# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum, this matches the default thread size of Active Record.

require 'dotenv'
Dotenv.load

threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }.to_i
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { 1 }.to_i
threads min_threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests, default is 3000.
#
port        ENV.fetch('PORT') { 3000 }

# Specifies the `environment` that Puma will run in.
#
rails_env = ENV['RAILS_ENV'] || 'development'
environment rails_env

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
workers ENV.fetch('WEB_CONCURRENCY') { 1 }

app_dir = File.expand_path('../..', __FILE__)
temp_dir = "#{app_dir}/tmp"

unless rails_env == 'development'
  stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

  # Set master PID and state locations
  pidfile "#{temp_dir}/pids/puma.pid"
  state_path "#{temp_dir}/pids/puma.state"

  activate_control_app

  daemonize

  on_worker_boot do
    config = ActiveRecord::Base.configurations[Rails.env] ||
             Rails.application.config.database_configuration[Rails.env]
    require 'active_record'
    begin
      ActiveRecord::Base.connection.disconnect!
    rescue
      ActiveRecord::ConnectionNotEstablished
    end
    ActiveRecord::Base.establish_connection(config)
  end
end

plugin 'tmp_restart'
