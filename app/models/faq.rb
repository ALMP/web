class Faq < ApplicationRecord
  translates :question, :answer, :fallbacks_for_empty_translations => true
  globalize_accessors locales: I18n.available_locales, attributes: [:question, :answer]

  validates :question_en, presence: true
  validates :answer_en, presence: true
end
