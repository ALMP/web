# frozen_string_literal: true
require 'test_helper'

class CompanyPresenterTest < ActiveSupport::TestCase
  def setup
    city = build :city, name: 'Moscow'
    company = build :company, url: 'http://example.com', city: city
    @company = Oprah.present company
  end

  def test_url_returns_without_scheme
    assert_equal 'example.com', @company.url
  end

  def test_details_with_all_data
    assert_equal 'example.com / Moscow', @company.details
  end

  def test_details_without_url
    @company.url = nil
    assert_equal 'Moscow', @company.details
  end

  def test_details_without_city
    @company.city = nil
    assert_equal 'example.com', @company.details
  end

  def test_empty_details
    @company.city = nil
    @company.url = nil
    assert @company.details.blank?
  end

  def test_empty_phone
    @company.phone = nil
    assert_equal '-', @company.phone
  end

  def test_empty_email
    @company.email = '  '
    assert_equal '-', @company.email
  end

  def test_empty_zipcode
    @company.zipcode = ''
    assert_equal '-', @company.zipcode
  end
end
