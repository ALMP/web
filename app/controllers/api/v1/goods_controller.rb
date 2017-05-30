# frozen_string_literal: true
module Api
  module V1
    class GoodsController < DictionaryController
      def resource_class
        Good
      end
    end
  end
end
