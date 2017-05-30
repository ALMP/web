# frozen_string_literal: true
require 'alibaba_suppliers_parser/pages/base'
# List of suppliers on tag page
# @example https://www.alibaba.com/bag-cellophane-suppliers.html
module AlibabaSuppliersParser
  module Pages
    class SuppliersList < Base
      def pages
        selector = "//div[@class='ui2-pagination-pages']/span[@class='disable']"
        page_count = response.search(selector).text.to_i
        1.upto(page_count).map do |num|
          {
            href: "#{url[0..-6]}_#{num}.html"
          }
        end
      end

      def suppliers
        selector = "//div[@class='corp']/div[@class='company']/a[1]"
        response.search(selector).map do |data|
          {
            href: build_href(data.attributes['href'].value),
            key: build_key(data.attributes['href'].value)
          }
        end
      end

      private

      def build_href(url)
        if url =~ /alibaba\.com\/member/
          return "https://#{url[2..-18]}.html"
        else
          return "https://#{url[2..-18]}"
        end
      end

      def build_key(url)
        if url =~ /alibaba\.com\/member/
          return url[25..-18]
        else
          return url[2..-40] if url =~ /trustpass/
          return url[2..-33]
        end
      end
    end
  end
end
