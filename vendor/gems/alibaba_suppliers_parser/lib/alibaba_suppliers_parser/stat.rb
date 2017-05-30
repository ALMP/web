# frozen_string_literal: true
require 'terminal-table'
require 'alibaba_suppliers_parser/runner'

module AlibabaSuppliersParser
  module Stat
    class << self
      def run
        data = Terminal::Table.new do |t|
          t << ['Suppliers downloaded', suppliers_downloaded]
          t << :separator
          t << ['Suppliers in queue', suppliers_in_queue]
          t << ['Tag urls in queue', tags_colections_in_queue]
          t << ['Pages with suppliers in queue', suppliers_pages_queue]
        end
        puts data
      end

      def tags_colections_in_queue
        redis.llen Runner::TAGS_LIST_URLS_QUEUE
      end

      def suppliers_pages_queue
        redis.llen Runner::SUPPLIERS_URLS_QUEUE
      end

      def suppliers_downloaded
        redis.scard Runner::SUPPLIERS_KEYS
      end

      def suppliers_in_queue
        redis.llen Runner::SUPPLIERS_QUEUE
      end

      def redis
        Redis.new
      end
    end
  end
end
