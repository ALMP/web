# frozen_string_literal: true
require 'test_helper'

class CityTest < ActiveSupport::TestCase
  should have_many(:companies)

  def test_factory_valid
    city = build :city
    assert city.valid?
  end

  def test_set_fallback_locale_name
    city = create :city, name_en: 'English', name_ru: 'Russian'
    assert_equal city.fallback_locale_name, 'English'
  end

  def test_set_fallbacke_locale_name_for_other_locales
    Globalize.with_locale(:ru) do
      city = create :city, name_en: 'English', name_ru: 'Russian'
      assert_equal city.fallback_locale_name, 'English'
    end
  end

  def test_autocomplete
    create :city, name_en: 'Test', name_ru: 'L-first word'
    create :city, name: 'Second', name_zh_cn: 'L-second word'

    assert_equal 2, City.autocomplete('l').count
    assert_equal 1, City.autocomplete('Sec').count
    assert_equal 2, City.autocomplete('wo').count
  end

  def test_as_json
    city = create :city, name_en: 'En', name_ru: 'Ru', name_zh_cn: 'Zh-cn'
    assert_equal 'En', city.as_json['name']
    assert_equal 'En', city.as_json['name_en']
    assert_equal 'Ru', city.as_json['name_ru']
    assert_equal 'Zh-cn', city.as_json['name_zh_cn']
  end

  def test_autocomplte_in_ransackable_scopes
    assert City.ransackable_scopes.include?('autocomplete')
  end
end
