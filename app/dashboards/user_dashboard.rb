# frozen_string_literal: true
require 'administrate/base_dashboard'
require 'administrate/field/enum'

class UserDashboard < BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    type: Field::Enum,
    email: Field::String,
    password: Field::String,
    recommendator: Field::String,
    sign_in_count: Field::Number,
    last_sign_in_at: Field::DateTime,
    created_at: Field::DateTime
  }.freeze

  def sort_ransackers
    {
      email: :email,
      type: :type,
      created_at: :created_at
    }
  end

  def search_attribute
    :email_cont
  end

  COLLECTION_ATTRIBUTES = [
    :id,
    :email,
    :type,
    :created_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :email,
    :type,
    :recommendator,
    :sign_in_count,
    :last_sign_in_at,
    :created_at
  ].freeze

  FORM_ATTRIBUTES = [
    :email,
    :password,
    :type
  ].freeze

  def display_resource(user)
    user.email
  end
end
