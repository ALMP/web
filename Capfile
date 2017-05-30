# frozen_string_literal: true
# Load DSL and set up stages
require 'capistrano/setup'

require 'capistrano/deploy'
require 'capistrano/git-submodule-strategy'
require 'capistrano/rails'
require 'capistrano/sidekiq'
require 'capistrano/bundler'
require 'capistrano/maintenance'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
