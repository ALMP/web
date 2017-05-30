# frozen_string_literal: true
require 'test_helper'

class GoodTest < ActiveSupport::TestCase
  should have_and_belong_to_many(:companies)

  def test_factory_valid
    good = build :good
    assert good.valid?
  end

  def test_set_fallback_locale_name
    good = create :good, name_en: 'English', name_ru: 'Russian'
    assert_equal good.fallback_locale_name, 'English'
  end

  def test_set_fallbacke_locale_name_for_other_locales
    Globalize.with_locale(:ru) do
      good = create :good, name_en: 'English', name_ru: 'Russian'
      assert_equal good.fallback_locale_name, 'English'
    end
  end

  def test_autocomplete
    create :good, name_en: 'Test', name_ru: 'L-first word'
    create :good, name: 'Second', name_zh_cn: 'L-second word'

    assert_equal 2, Good.autocomplete('l').count
    assert_equal 1, Good.autocomplete('Sec').count
    assert_equal 2, Good.autocomplete('wo').count
  end

  def test_as_json
    good = create :good, name_en: 'En', name_ru: 'Ru', name_zh_cn: 'Zh-cn'
    assert_equal 'En', good.as_json['name']
    assert_equal 'En', good.as_json['name_en']
    assert_equal 'Ru', good.as_json['name_ru']
    assert_equal 'Zh-cn', good.as_json['name_zh_cn']
  end

  def test_autocomplte_in_ransackable_scopes
    assert Good.ransackable_scopes.include?('autocomplete')
  end
end
