# frozen_string_literal: true
class AggregatedRating < ApplicationRecord
  belongs_to :company

  def recommended
    (100 * self[:recommended]).to_i
  end

  def thankful
    (100 * self[:thankful]).to_i
  end
end
