# frozen_string_literal: true
module Api
  module V1
    class CitiesController < DictionaryController
      def resource_class
        City
      end
    end
  end
end
