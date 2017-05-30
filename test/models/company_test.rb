# frozen_string_literal: true
require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  # associations
  should belong_to(:city)
  should have_and_belong_to_many(:categories)
  should have_and_belong_to_many(:goods)

  def test_factory_valid
    company = build :company
    assert company.valid?
  end

  # email validations

  def test_email_invalid_if_has_no_domain
    company = build :company, email: 'invalid'
    assert company.invalid?
  end

  def test_email_invalid_if_has_no_name
    company = build :company, email: 'invalid.com'
    assert company.invalid?
  end

  # phone validations

  def test_phone_invalid_if_no_digits
    company = build :company, phone: 'invalid'
    assert company.invalid?
  end

  # zipcode validations

  def test_zipcode_invalid_with_letters
    company = build :company, zipcode: 'abc'
    assert company.invalid?
  end

  def test_zipcode_valid_with_digits
    company = build :company, zipcode: '123'
    assert company.valid?
  end

  def test_city_name_scope
    ru = City.create name_ru: 'Москва', name_en: 'Minsk'
    en = City.create name_en: 'Minsk'
    create :company, city: ru
    create :company, city: en
    Globalize.with_locale(:ru) do
      cities = Company.with_city_name.map(&:city_name)
      assert_equal cities, %w(Москва Minsk)
    end
  end

  def test_pagination_interval
    10.times { create :company }
    interval = Company.page(2).per(3).pagination_interval
    assert_equal (4...6), interval
  end

  def test_pagination_interval_for_last_page
    10.times { create :company }
    interval = Company.page(2).per(9).pagination_interval
    assert_equal (10...10), interval
  end

  def test_russian_term_search
    create :company, name: 'Русский', description: 'Язык'
    assert_equal 1, Company.term('Русские', 'ru').count
  end

  def test_english_term_search
    create :company, name: 'Table', description: 'Language'
    assert_equal 1, Company.term('Table', 'en').count
    assert_equal 1, Company.term('Tables', :en).count
  end

  def test_globalize_term_detection
    Globalize.with_locale 'zh-CN' do
      create :company, name: 'Table', description: 'Language'
      assert_equal 1, Company.term('Table').count
      assert_equal 0, Company.term('Tables').count
    end
  end

  def test_aliases
    company = create :company
    create :company_alias, name: 'A', company: company
    create :company_alias, name: 'B', company: company
    assert_equal 'A, B', company.aliases
  end

  def test_aggregated_rating_creation
    company = create :company
    assert company.aggregated_rating.present?
  end
end
