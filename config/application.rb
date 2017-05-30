# frozen_string_literal: true
require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require "action_cable/engine"
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CompaniesReviews
  class Application < Rails::Application
    config.rack_dev_mark.enable = !Rails.env.production?

    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    config.responders.flash_keys = [ :success, :error ]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.eager_load_paths.push("#{config.root}/app/interactors")
    config.eager_load_paths.push("#{config.root}/app/inputs")

    config.cache_store = :redis_store, {
      host: 'localhost',
      port: 6379,
      db: 0,
      namespace: 'cache',
      expires_in: 30.minutes
    }

    config.generators do |g|
      g.test_framework :minitest, spec: false, fixture: false
      g.helpers false
      g.assets false
    end

    config.active_record.schema_format = :sql

    config.to_prepare do
      Administrate::ApplicationController.helper CompaniesReviews::Application.helpers
    end

    config.action_mailer.default_url_options = {
      host: Rails.application.secrets.host
    }
  end
end
