# frozen_string_literal: true
require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  should have_and_belong_to_many(:companies)

  def test_factory_valid
    category = build :category
    assert category.valid?
  end

  def test_set_fallback_locale_name
    category = create :category, name_en: 'English', name_ru: 'Russian'
    assert_equal category.fallback_locale_name, 'English'
  end

  def test_set_fallbacke_locale_name_for_other_locales
    Globalize.with_locale(:ru) do
      category = create :category, name_en: 'English', name_ru: 'Russian'
      assert_equal category.fallback_locale_name, 'English'
    end
  end

  def test_autocomplete
    create :category, name_en: 'Test', name_ru: 'L-first word'
    create :category, name: 'Second', name_zh_cn: 'L-second word'

    assert_equal 2, Category.autocomplete('l').count
    assert_equal 1, Category.autocomplete('Sec').count
    assert_equal 2, Category.autocomplete('wo').count
  end

  def test_as_json
    category = create :category, name_en: 'En', name_ru: 'Ru', name_zh_cn: 'Zh-cn'
    assert_equal 'En', category.as_json['name']
    assert_equal 'En', category.as_json['name_en']
    assert_equal 'Ru', category.as_json['name_ru']
    assert_equal 'Zh-cn', category.as_json['name_zh_cn']
  end

  def test_autocomplte_in_ransackable_scopes
    assert Category.ransackable_scopes.include?('autocomplete')
  end
end
