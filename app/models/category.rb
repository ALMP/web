# frozen_string_literal: true
class Category < ApplicationRecord
  include Companies::TranslatableDictionary
  include Paginatable

  has_and_belongs_to_many :companies
  has_many :goods

  scope :with_name, lambda {
    select("#{table_name}.*, COALESCE(#{translations_table_name}.name,
           #{table_name}.fallback_locale_name) as category_name")
      .joins("LEFT OUTER JOIN #{translations_table_name}
             ON #{translations_table_name}.category_id = #{table_name}.id
             AND #{translations_table_name}.locale = '#{Globalize.locale}'")
  }

  ransacker :name do
    Arel.sql('category_name')
  end

  def ransackable_attributes
    super + ['category_name']
  end

  def ransackable_associations
    %w(translations)
  end
end
