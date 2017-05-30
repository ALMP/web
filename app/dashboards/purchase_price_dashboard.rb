# frozen_string_literal: true
require 'administrate/base_dashboard'
require 'administrate/field/enum'

class PurchasePriceDashboard < BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    name: Field::String,
    company: Field::BelongsTo.with_options(source: [:api, :v1, :companies]),
    user: Field::BelongsTo.with_options(class_name: 'User', source: [:api, :v1, :users]),
    status: Field::Enum,
    kind: Field::Enum,
    value: Field::Number,
    quantity: Field::Number,
    unit: Field::Enum,
    id: Field::Number
  }.freeze

  # SORT_RANSACKERS
  # a hash that describes the ransacker for each of model's fields
  def sort_ransackers
    {
      name: :name, company: :company_name, user: :user_email, value: :value_cents, kind: :kind, unit: :unit, status: :status, quantity: :quantity
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
    :name,
    :company,
    :status,
    :kind,
    :quantity,
    :unit,
    :value
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :name,
    :company,
    :status,
    :user,
    :kind,
    :quantity,
    :unit,
    :value
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :company,
    :user,
    :status,
    :kind,
    :quantity,
    :unit,
    :value
  ].freeze

  # Overwrite this method to customize how goods are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(price)
    price.name
  end
end
