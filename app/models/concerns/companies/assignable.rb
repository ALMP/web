# frozen_string_literal: true
# Assign company by its name
module Companies
  module Assignable
    extend ActiveSupport::Concern

    included do
      validates :company_name, presence: true
      validate :company_not_exists

      before_validation :find_company, if: :company_name
    end

    def company_name
      super || company&.name
    end

    protected

    def find_company
      self.company_id = Company.find_by(name: company_name)&.id
    end

    def company_not_exists
      errors.add :company_name, :not_exists if company_id.blank?
    end
  end
end
