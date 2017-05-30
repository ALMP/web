# frozen_string_literal: true
require 'alibaba_suppliers_parser/pages/base'
# Alphabetical tags list page
# @example: https://www.alibaba.com/suppliers/supplier-B_42.html
module AlibabaSuppliersParser
  module Pages
    class TagsList < Base
      def tags
        selector = "//div[@class='colRmargin']/div[@class='column one4']/a"
        response.search(selector).map do |link|
          {
            key: link.text[0..-11],
            href: link.attributes['href'].value
          }
        end
      end

      def pages
        selector = "//span[@id='PagesBoxPageAll']//a"
        response.search(selector).map do |link|
          { href: "#{domain}#{link.attributes['href'].value}" }
        end
      end
    end
  end
end
