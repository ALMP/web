# frozen_string_literal: true
require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  def test_factory_valid
    admin = build :admin_user
    assert admin.valid?
  end
end
