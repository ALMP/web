# frozen_string_literal: true
module Api
  module V1
    class DictionaryController < ApplicationController
      respond_to :json

      def index
        render json: resource_class.ransack(params).result.limit(10)
      end

      protected

      def resource_class
        raise NotImplementedError
      end
    end
  end
end
