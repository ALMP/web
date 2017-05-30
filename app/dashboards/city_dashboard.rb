# frozen_string_literal: true
require 'administrate/base_dashboard'

require 'administrate/field/place'

class CityDashboard < BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    name: Field::Place.with_options(locale: Globalize.locale),
    name_en: Field::Place.with_options(locale: :en),
    name_ru: Field::Place.with_options(locale: :ru),
    name_zh_cn: Field::Place.with_options(locale: 'zh-CN'),
    id: Field::Number
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :id
  ].freeze

  # SORT_RANSACKERS
  # a hash that describes the ransacker for each of model's fields
  def sort_ransackers
    {
      name: :name
    }
  end

  def search_attribute
    :translations_name_cont
  end

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name_en,
    :name_ru,
    :name_zh_cn
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name_en,
    :name_ru,
    :name_zh_cn
  ].freeze

  # Overwrite this method to customize how goods are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(city)
    city.name
  end
end
