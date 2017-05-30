# frozen_string_literal: true
require 'terminal-table'
require 'alibaba_suppliers_parser/showcase/tags_list'
require 'alibaba_suppliers_parser/showcase/suppliers_list'
require 'alibaba_suppliers_parser/showcase/supplier'
require 'alibaba_suppliers_parser/version'

module AlibabaSuppliersParser
  module Showcase
    class << self
      def run
        headings = Terminal::Table.new do |t|
          t << ['Alibaba suppliers parser', AlibabaSuppliersParser::VERSION]
        end
        puts headings

        data = AlibabaSuppliersParser::Showcase::TagsList.new('https://www.alibaba.com/suppliers/supplier-B_42.html').data
        tags_list = Terminal::Table.new do |t|
          t << ['Page', 'List with tags']
          t << ['Url', data[:url]]
          t.add_row ['Code', data[:code]]
          t << :separator
          t.add_row ["Pages.\nTagsList#pages", data[:pages].take(5).push("... #{data[:pages].count} total").join("\n")]
          t << :separator
          t.add_row ["Tags.\nTagsList#tags", data[:tags].take(5).push("... #{data[:tags].count} total").join("\n")]
        end
        puts tags_list

        data = AlibabaSuppliersParser::Showcase::SuppliersList.new('https://www.alibaba.com/bag-cellophane-suppliers_21.html').data
        suppliers_list = Terminal::Table.new do |t|
          t << ['Page', 'List with suppliers']
          t << ['Url', data[:url]]
          t.add_row ['Code', data[:code]]
          t << :separator
          t.add_row ["Pages.\nSuppliersList#pages", data[:pages].take(5).push("... #{data[:pages].count} total").join("\n")]
          t << :separator
          t.add_row ["Suppliers.\nSuppliersList#suppliers", data[:suppliers].take(5).push("... #{data[:suppliers].count} total").join("\n")]
        end
        puts suppliers_list

        data = AlibabaSuppliersParser::Showcase::Supplier.new('https://asiaexpo.trustpass.alibaba.com').data
        supplier = Terminal::Table.new do |t|
          t << ['Page', 'List with suppliers']
          t << ['Url', data[:url]]
          t.add_row ['Code', data[:code]]
          t << :separator
          t << ['Key', data[:key]]
          t << ['Name', data[:name]]
          t << ['Website', data[:website]]
          t << ['Address', data[:address]]
          t << ['Type', data[:type]]
          t << ['Location', data[:location]]
          t << ['Goods', data[:goods]]
          t << ['Logo', data[:logo]]
          t << ['Description', data[:description]]
        end
        puts supplier
      end
    end
  end
end
