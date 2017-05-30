# frozen_string_literal: true
require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'minitest/rails'
require 'minitest/pride'

# simplecov
require 'simplecov'
SimpleCov.start 'rails'

# FactoryGirl model factories
require 'factory_girl'

module ActiveSupport
  class TestCase
    ActiveRecord::Migration.check_pending!

    include FactoryGirl::Syntax::Methods

    require 'enumerize/integrations/rspec'
    extend Enumerize::Integrations::RSpec
  end
end

# Should-matchers matchers
require 'shoulda'
require 'shoulda/matchers'

# Fakeredis
require 'fakeredis'
