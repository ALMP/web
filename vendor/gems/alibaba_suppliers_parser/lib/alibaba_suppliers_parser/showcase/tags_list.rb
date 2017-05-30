# frozen_string_literal: true
require 'alibaba_suppliers_parser/showcase/base'
require 'alibaba_suppliers_parser/pages/tags_list'

module AlibabaSuppliersParser
  module Showcase
    class TagsList < Base
      def data
        # prepare
        page.on_page
        {
          url: url,
          code: response.code,
          pages: pages,
          tags: tags
        }
      end

      def initialize(url)
        @url = url
        @page = Pages::TagsList.new @url
      end

      def response
        page.response
      end

      def pages
        page.pages.map { |l| l[:href] }
      end

      def tags
        page.tags.map { |l| "key: #{l[:key]}, href: #{l[:href]}" }
      end
    end
  end
end
