require "administrate/base_dashboard"

class FaqDashboard < BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    question: Field::String,
    question_ru: Field::String,
    question_en: Field::String,
    question_zh_cn: Field::String,
    answer: Field::Text,
    answer_ru: Field::Text,
    answer_en: Field::Text,
    answer_zh_cn: Field::Text,
    id: Field::Number,
    position: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :question,
    :answer
  ].freeze

  def sort_ransackers
    {
      position: :position
    }
  end

  def search_attribute
    :question
  end

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :question_en,
    :answer_en,
    :question_ru,
    :answer_ru,
    :question_zh_cn,
    :answer_zh_cn,
    :position,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :question_en,
    :answer_en,
    :question_ru,
    :answer_ru,    
    :question_zh_cn,
    :answer_zh_cn,
  ].freeze

  # Overwrite this method to customize how faqs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(faq)
  #   "Faq ##{faq.id}"
  # end
end
