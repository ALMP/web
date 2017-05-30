# frozen_string_literal: true
require 'administrate/base_dashboard'
require 'administrate/field/enum'
require 'administrate/field/star'
require 'administrate/field/rating'

class ReviewDashboard < BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    company: Field::BelongsTo.with_options(source: [:api, :v1, :companies]),
    user: Field::BelongsTo.with_options(class_name: 'User', source: [:api, :v1, :users]),
    status: Field::Enum,
    rating: Field::Star,
    fairness: Field::Star,
    advantages: Field::Text,
    disadvantages: Field::Text,
    recommendations: Field::Text,
    quality: Field::Star,
    payments: Field::Star,
    service: Field::Star,
    stability: Field::Star,
    thankful: Field::Boolean.with_options(inline: true),
    custom_rating: Field::Rating.with_options(skip: [:review]),
    recommended: Field::Boolean.with_options(inline: true),
    terms_of_use_confirmed: Field::Boolean.with_options(inline: true),
    created_at: Field::DateTime
  }.freeze

  # SORT_RANSACKERS
  # a hash that describes the ransacker for each of model's fields
  def sort_ransackers
    {
      name: :name, company: :company_name, status: :status, created_at: :created_at, rating: :rating
    }
  end

  def search_attribute
    :name_or_company_name_cont
  end

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :status,
    :company,
    :rating,
    :created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :company,
    :user,
    :status,
    :rating,
    :advantages,
    :disadvantages,
    :recommendations,
    :quality,
    :payments,
    :service,
    :stability,
    :fairness,
    :custom_rating,
    :thankful,
    :recommended,
    :terms_of_use_confirmed,
    :created_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :status,
    :company,
    :user,
    :advantages,
    :disadvantages,
    :recommendations,
    :fairness,
    :quality,
    :payments,
    :service,
    :stability,
    :custom_rating,
    :thankful,
    :recommended,
    :terms_of_use_confirmed
  ].freeze

  # Overwrite this method to customize how categories are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(review)
    review.name
  end
end
