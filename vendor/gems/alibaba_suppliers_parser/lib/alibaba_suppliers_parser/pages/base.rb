# frozen_string_literal: true
require 'alibaba_suppliers_parser/errors/page_unsuccessfull_status'
require 'mechanize'

module AlibabaSuppliersParser
  module Pages
    class Base
      attr_reader :url, :options, :response

      def initialize(url, options = {})
        @url = url
        @options = options
      end

      def response
        on_page
      end

      def on_page
        @response = agent.get(url) do |data|
          raise Errors::PageUnsuccessfullStatus if data.code != '200'
          yield if block_given?
        end
      rescue Net::HTTPNotFound
        @response
      end

      protected

      def domain
        'https://www.alibaba.com'
      end

      private

      def agent
        @agent ||= Mechanize.new(options)
      end
    end
  end
end
