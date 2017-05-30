# frozen_string_literal: true
module Api
  module V1
    class UsersController < DictionaryController
      def index
        render json: resource_class.ransack(params).result.limit(10), methods: :name
      end

      def resource_class
        User
      end
    end
  end
end
