# frozen_string_literal: true
module Api
  module V1
    class CompaniesController < DictionaryController
      def resource_class
        Company
      end
    end
  end
end
