# frozen_string_literal: true
require 'test_helper'

class AggregatedRatingTest < ActiveSupport::TestCase
  attr_reader :company

  TEST_DATA = [
    { status: :declined },
    { status: :pending, rating: 3, fairness: 1 },
    { status: :confirmed, rating: 5 },
    { status: :confirmed, fairness: 3, rating: 4 },
    { status: :confirmed, quality: 3, rating: 4 },
    { status: :confirmed, payments: 4, rating: 2 },
    { status: :confirmed, stability: 1, rating: 5 },
    { status: :confirmed, service: 5, rating: 5 },
    { status: :confirmed, thankful: true, recommended: true },
    { status: :confirmed, recommended: true },
    { status: :declined, recommended: true }
  ].freeze

  def prepare_rating_test
    @company = create :company
    TEST_DATA.each do |data|
      create :review, company: company, **data
    end
  end

  def test_reviews_count
    prepare_rating_test
    assert_equal 8, company.confirmed_reviews_count
  end

  def test_rating
    prepare_rating_test
    assert_equal 2.0, company.rating.to_f
  end

  def test_fairness
    prepare_rating_test
    assert_equal 3.0, company.fairness.to_f
  end

  def test_quality
    prepare_rating_test
    assert_equal 3.0, company.quality.to_f
  end

  def test_payments
    prepare_rating_test
    assert_equal 4.0, company.payments.to_f
  end

  def test_stability
    prepare_rating_test
    assert_equal 1.0, company.stability.to_f
  end

  def test_service
    prepare_rating_test
    assert_equal 5.0, company.service.to_f
  end

  def test_recommended
    prepare_rating_test
    assert_equal 25, company.recommended
  end

  def test_thankful
    prepare_rating_test
    assert_equal 12, company.thankful
  end
end
