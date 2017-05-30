# frozen_string_literal: true
require 'test_helper'

class CompanyAliasTest < ActiveSupport::TestCase
  def test_valid
    assert build(:company_alias)
  end
end
