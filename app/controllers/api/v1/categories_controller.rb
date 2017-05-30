# frozen_string_literal: true
module Api
  module V1
    class CategoriesController < DictionaryController
      def resource_class
        Category
      end
    end
  end
end
