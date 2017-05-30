# frozen_string_literal: true
require 'administrate/base_dashboard'

class PublicationDashboard < BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    
    head: Field::Text,
    annotation: Field::Text,
    link: Field::String,
    company: Field::BelongsTo.with_options(source: [:api, :v1, :companies]),
    date_of_publication: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # SORT_RANSACKERS
  # a hash that describes the ransacker for each of model's fields
  def sort_ransackers
    {
      link: :link, company: :company_name, date_of_publication: :date_of_publication, created_at: :created_at
    }
  end

  def search_attribute
    :link_or_company_name_cont
  end

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :link,
    :head,
    :annotation,
    :company,
    :date_of_publication,
    :created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :link,
    :company,
    :head,
    :annotation,
    :date_of_publication,
    :created_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :link,
    :company,
    :head,
    :annotation,
    :date_of_publication
  ].freeze
  
 
end
