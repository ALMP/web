# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.1'

gem 'dotenv-rails', require: 'dotenv/rails-now'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'high_voltage'
gem 'locations', git: 'git@git.raisintech.com:companies_reviews/locations.git'
gem 'ruby-progressbar'

# Caching
gem 'redis-rails'
# Environment ribbon
gem 'rack-dev-mark'

gem 'simple_xlsx_reader'
gem 'simple_form'
gem 'record_tag_helper'
gem 'money-rails'
gem 'responders'
gem 'sinatra', '~> 2.0.0.beta2'
gem 'nokogiri'
gem 'metamagic'
gem 'google-analytics-rails'
# Enum selects
gem 'enumerize'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Extra validations
gem 'rails_validations'
# Slim templates
gem 'slim-rails'
# Presenters
gem 'oprah', github: 'endofunky/oprah'
# File uploads
gem 'carrierwave'
gem 'selectize-rails'
gem 'datetime_picker_rails'
gem 'twitter-typeahead-rails'
# Admin panel
# TODO: lock version after gem rails5 support
gem 'administrate', github: 'thoughtbot/administrate'

# Foreman to control application startup
gem 'foreman'

# Async work
gem 'sidekiq'
gem 'sidekiq-scheduler'

# Business logic services
gem 'active_interaction'

gem 'rails_autolink'
gem 'ransack'

gem 'flutie'
# Common i18n & l10n data
gem 'rails-i18n', '~> 5.0.0'

# Translate activerecord attributes
gem 'globalize', github: 'globalize/globalize'
gem 'globalize-accessors'
gem 'activemodel-serializers-xml'

# Authentication
gem 'devise'
gem 'omniauth-vkontakte'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-weibo-oauth2'
gem 'omniauth-oauth2'
gem 'devise-i18n'

gem 'select2-rails'

gem 'pg_search'
gem 'versionist'

# Scss tools
gem 'bourbon'
gem 'neat'
gem 'refills'
gem 'bitters'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end
gem 'bootstrap', '= 4.0.0.alpha6'

gem 'font-awesome-rails'
gem 'tooltipster-rails'
gem 'autoprefixer-rails'

# Use Capistrano for deployment
gem 'capistrano-rails', group: :development
gem 'capistrano-sidekiq'
gem 'capistrano-maintenance', require: false
gem 'capistrano-git-submodule-strategy', '~> 0.1'

gem 'bing_translator', '~> 4.6.0'
gem 'json', '~> 1.8.0'

gem 'rails_autolink'
gem 'lograge'
gem 'nested_form'

group :staging, :production do
  gem 'puma', '~> 3.0'
end

group :development, :test, :ci do
  gem 'minitest-rails'
  gem 'pry-rails'
end

group :test, :ci do
  gem 'simplecov', require: false
  gem 'shoulda', '~> 3.5'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers', '~> 2.0'
  gem 'fakeredis'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'listen', '~> 3.0.5'
  gem 'rubocop', require: false
  gem 'letter_opener'
  gem 'thin'
  gem 'bullet'
  gem 'ruby-growl'
end
