# frozen_string_literal: true
require 'alibaba_suppliers_parser/showcase/base'
require 'alibaba_suppliers_parser/pages/suppliers_list'

module AlibabaSuppliersParser
  module Showcase
    class SuppliersList < Base
      def data
        # prepare
        page.on_page
        {
          url: url,
          code: response.code,
          pages: pages,
          suppliers: suppliers
        }
      end

      def initialize(url)
        @url = url
        @page = Pages::SuppliersList.new @url
      end

      def response
        page.response
      end

      def pages
        page.pages.map { |l| l[:href] }
      end

      def suppliers
        page.suppliers.map { |l| "key: #{l[:key]}, href: #{l[:href]}" }
      end
    end
  end
end
