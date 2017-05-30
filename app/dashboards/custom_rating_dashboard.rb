# frozen_string_literal: true
require 'administrate/base_dashboard'
require 'administrate/field/star'
require 'administrate/field/star'

class CustomRatingDashboard < BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    title: Field::String,
    value: Field::Star,
    review: Field::BelongsTo,
    id: Field::Number
  }.freeze

  # SORT_RANSACKERS
  # a hash that describes the ransacker for each of model's fields
  def sort_ransackers
    {
      title: :title, value: :value, review: :review_name
    }
  end

  def search_attribute
    :title_cont
  end

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :title,
    :review,
    :value,
    :id
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :title,
    :review,
    :value,
    :id
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :value
  ].freeze

  # Overwrite this method to customize how goods are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(custom_rating)
    "#{custom_rating.title}: #{custom_rating.value}"
  end
end
