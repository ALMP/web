# frozen_string_literal: true require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  def review
    @review ||= build :review
  end

  def test_valid
    assert review.valid?
  end

  def test_valid_company_setting
    create :company, name: 'valid'
    review = build :review, company: nil, company_name: 'valid'
    assert review.valid?
  end

  def test_company_name
    review = build :review, company_name: 'initial'
    assert_equal 'initial', review.company_name
  end

  def test_associated_company_name
    company = create :company, name: 'remote'
    review = build :review, company: company
    assert_equal 'remote', review.company_name
  end

  def test_rating_validation
    review = build :review, rating: 2
    assert review.valid?
  end

  def test_quality_validation
    review = build :review, quality: 4.3
    refute review.valid?
    review = build :review, quality: 2
    assert review.valid?
  end

  def test_payments_validation
    review = build :review, payments: -1
    refute review.valid?
    review = build :review, payments: nil
    assert review.valid?
  end

  def test_service_validation
    review = build :review, service: 2.1
    refute review.valid?
    review = build :review, service: 5
    assert review.valid?
  end
end
