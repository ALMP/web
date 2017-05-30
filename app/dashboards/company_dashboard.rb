# frozen_string_literal: true
require 'administrate/base_dashboard'

require 'administrate/field/image'
require 'administrate/field/place'
require 'administrate/field/has_many_dictionary'
require 'administrate/field/url'
require 'administrate/field/nested_has_many'
require 'administrate/field/star'

class CompanyDashboard < BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    url: Field::Url,
    aliases: Field::String,
    categories: Field::HasManyDictionary.with_options(source: [:api, :v1, :categories]),
    goods: Field::HasManyDictionary.with_options(source: [:api, :v1, :goods]),
    city: Field::BelongsTo.with_options(source: [:api, :v1, :cities]),
    logo: Field::Image,
    company_aliases: Field::NestedHasMany.with_options(skip: :company),
    zipcode: Field::String,
    address: Field::Place,
    email: Field::String,
    description: Field::Text,
    phone: Field::String,
    confirmed_reviews_count: Field::Number,
    rating: Field::Star,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  def search_attribute
    :q_cont
  end

  # SORT_RANSACKERS
  # a hash that describes the ransacker for each of model's fields
  def sort_ransackers
    {
      url: :url, name: :name, logo: :logo, rating: :aggregated_rating_rating, confirmed_reviews_count: :aggregated_rating_confirmed_reviews_count,
      city: :city_name, address: :address, email: :email, phone: :phone, created_at: :created_at, zipcode: :zipcode
    }.freeze
  end
  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :logo,
    :name,
    :categories,
    :goods,
    :url,
    :zipcode,
    :email,
    :phone,
    :city,
    :address,
    :created_at,
    :confirmed_reviews_count,
    :rating
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :aliases,
    :logo,
    :categories,
    :goods,
    :city,
    :address,
    :zipcode,
    :url,
    :email,
    :phone,
    :description,
    :confirmed_reviews_count,
    :rating,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :company_aliases,
    :logo,
    :categories,
    :goods,
    :city,
    :zipcode,
    :url,
    :email,
    :phone,
    :description
  ].freeze

  # Overwrite this method to customize how companies are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(company)
    company.name
  end

  def permitted_attributes
    super + [:remove_logo, { company_aliases_attributes: [:name, :id, :_destroy] }]
  end
end
