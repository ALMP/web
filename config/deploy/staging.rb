# frozen_string_literal: true
# server-based syntax
server '139.162.184.177', user: 'companies_reviews', roles: %w(app web), my_property: :my_value

# If the environment differs from the stage name
set :rails_env, 'staging'

# Defaults to :db role
set :migration_role, :app

# Defaults to the primary :db server
set :migration_servers, -> { primary(fetch(:migration_role)) }

# Defaults to false
# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, false

# Defaults to [:web]
set :assets_roles, [:app]

set :branch, :master

# Defaults to 'assets'
# This should match config.assets.prefix in your rails config/application.rb
# set :assets_prefix, 'assets'

# If you need to touch public/images, public/javascripts, and public/stylesheets on each deploy
set :normalize_asset_timestamps, %w(public/images public/javascripts public/stylesheets)

# Defaults to nil (no asset cleanup is performed)
# If you use Rails 4+ and you'd like to clean up old assets after each deploy,
# set this to the number of versions to keep
set :keep_assets, 2
