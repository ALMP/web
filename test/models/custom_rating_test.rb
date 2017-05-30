# frozen_string_literal: true
require 'test_helper'

class CustomRatingTest < ActiveSupport::TestCase
  def custom_rating
    @custom_rating ||= build(:custom_rating)
  end

  def test_valid
    assert custom_rating.valid?
  end
end
