# frozen_string_literal: true
class CompanyAlias < ApplicationRecord
  belongs_to :company

  validates :name, presence: true
end
