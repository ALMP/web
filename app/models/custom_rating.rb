# frozen_string_literal: true
class CustomRating < ApplicationRecord
  belongs_to :review, touch: true

  validates :title, presence: true
  validates :value,
            numericality: { greater_than: 0, only_integer: true, less_than_or_equal_to: 5 },
            if: :title?
end
