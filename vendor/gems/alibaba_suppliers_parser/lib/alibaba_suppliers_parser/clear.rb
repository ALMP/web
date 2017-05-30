# frozen_string_literal: true
require 'alibaba_suppliers_parser/runner'

module AlibabaSuppliersParser
  module Clear
    class << self
      def run(options = {})
        redis = Redis.new
        keys = [
          Runner::TAGS_URLS_QUEUE,
          Runner::TAGS,
          Runner::SUPPLIERS_URLS_QUEUE,
          Runner::SUPPLIERS_QUEUE,
          Runner::SUPPLIERS,
          Runner::SUPPLIERS_KEYS
        ]
        keys.push(Runner::TAGS_LIST_URLS_QUEUE) if options.all
        keys.each do |key|
          redis.del key
        end
      end
    end
  end
end
