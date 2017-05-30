# frozen_string_literal: true
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_presence_of(:email)
  should validate_uniqueness_of(:email)

  def test_factory_valid
    user = build :user
    assert user.valid?
  end
end
