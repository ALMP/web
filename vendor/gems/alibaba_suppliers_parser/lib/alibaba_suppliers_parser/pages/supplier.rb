# frozen_string_literal: true
require 'alibaba_suppliers_parser/pages/base'
# Alphabetical tags list page
# @example: https://www.alibaba.com/suppliers/supplier-B_42.html
module AlibabaSuppliersParser
  module Pages
    class Supplier < Base
      def address
        selector = "//th//text()[contains(., 'Address')]/../../td[not(@*)]"
        contactinfo_response.search(selector).text.strip
      end

      def website
        selector = "//th//text()[contains(., 'Website:')]/../../td[not(@*)]/a[1]"
        contactinfo_response.search(selector).text.strip
      end

      def name
        selector = "//*[@class='m-header']/h3"
        details_response.search(selector).text.strip
      end

      def type
        selector = "//*[@data-role='companyBusinessType']/td[@class='col-value']"
        details_response.search(selector)&.text.to_s.strip
      end

      def location
        details_response.search("//*[@data-role='companyLocation']/td[@class='col-value']")&.text.to_s.strip
      end

      def goods
        details_response.search("//*[@data-role='supplierMainProducts']/td[@class='col-value']")&.text.to_s.strip
      end

      def description
        details_response.search("//*[@class='company-description company-description-full']")[0]&.text.to_s.strip
      end

      def logo
        details_response.search("//*[@class='company-logo']//img[1]")[0]&.attribute('src')&.value.to_s[2..-1]
      end

      def key
        if url =~ /alibaba\.com\/member/
          return url[31..-6]
        else
          return url[8..-23] if url =~ /trustpass/
          return url[8..-16]
        end
      end

      def details_response
        profile_page_url = "#{url}/company_profile.html"
        @details_response ||= agent.get(profile_page_url)
      end

      def contactinfo_response
        contactinfo_url = "#{url}/contactinfo.html"
        @contactinfo_response ||= agent.get(contactinfo_url)
      end
    end
  end
end
