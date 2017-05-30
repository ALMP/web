# frozen_string_literal: true
require 'alibaba_suppliers_parser/showcase/base'
require 'alibaba_suppliers_parser/pages/supplier'

module AlibabaSuppliersParser
  module Showcase
    class Supplier < Base
      def data
        page.on_page
        {
          url: url,
          code: response.code,
          key: page.key,
          website: page.website,
          address: page.address,
          name: page.name,
          type: page.type,
          location: page.location,
          goods: page.goods,
          logo: page.logo,
          description: page.description
        }
      end

      def initialize(url)
        @url = url
        @page = Pages::Supplier.new @url
      end

      def response
        page.response
      end
    end
  end
end
