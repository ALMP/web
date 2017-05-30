# frozen_string_literal: true
class City < ApplicationRecord
  include Companies::TranslatableDictionary

  has_many :companies

  scope :with_name, lambda {
                      select("#{table_name}.*,
                             COALESCE(#{translations_table_name}.name,
                             #{table_name}.fallback_locale_name) as city_name")
                        .joins("LEFT OUTER JOIN #{translations_table_name}
                               ON #{translations_table_name}.city_id = #{table_name}.id
                               AND #{translations_table_name}.locale = '#{Globalize.locale}'")
                    }

  ransacker :name do
    Arel.sql('city_name')
  end

  def ransackable_attributes
    super + ['city_name']
  end

  def ransackable_associations
    %w(translations)
  end
end
