# frozen_string_literal: true
require 'redis'
require 'redis-queue'
require 'parallel'
require 'alibaba_suppliers_parser/pages'
require 'chrono_logger'

module AlibabaSuppliersParser
  module Runner
    # list
    TAGS_LIST_URLS_QUEUE = 'alibaba:tags:list:urls:queue'
    # list
    TAGS_URLS_QUEUE = 'alibaba:tags:urls:queue'
    # set
    TAGS = 'alibaba:tags'

    # list
    SUPPLIERS_URLS_QUEUE = 'alibaba:suppliers:urls:queue'
    # list
    SUPPLIERS_QUEUE = 'alibaba:suppliers:queue'
    # hset
    SUPPLIERS = 'alibaba:suppliers'
    # set
    SUPPLIERS_KEYS = 'alibaba:suppliers_keys'

    # in seconds
    TIMEOUT = 60

    class << self
      def run(command)
        public_send command
      end

      def logger
        @logger ||= ChronoLogger.new(STDOUT)
      end

      def log(channel, message)
        logger.public_send channel, message
      end

      def mutex
        @mutex ||= Mutex.new
      end

      def prepare
        redis.del TAGS_LIST_URLS_QUEUE

        letters = ('A'..'Z').to_a.push('0-9')
        category_url = 'https://www.alibaba.com/suppliers/supplier-<<LETTER>>.html'
        letters.each do |letter|
          url = category_url.gsub '<<LETTER>>', letter
          page = Pages::TagsList.new(url)
          pagination_links = page.pages.map { |a| a[:href] }
          log :info, "Save #{pagination_links.size} pages with tags for letter #{letter}"
          redis.lpush TAGS_LIST_URLS_QUEUE, pagination_links
        end
      end

      def redis
        @redis ||= Redis.new
      end

      def save_suppliers_collection
        # sample item https://www.alibaba.com/suppliers/supplier-A.html
        tags_list_urls_queue.process(false, TIMEOUT) do |tags_collection_url|
          page = Pages::TagsList.new(tags_collection_url)
          page.tags.each do |tag|
            redis.lpush TAGS, tag[:key]

            # sample https://www.alibaba.com/access-tv-suppliers.html
            pages = Pages::SuppliersList.new(tag[:href]).pages
            pages.each do |page|
              # sample https://www.alibaba.com/accessory-laptop-suppliers_71.html
              suppliers_urls_queue.push page[:href]
            end
            log :info, "Save #{pages.count} pages with suppliers with tag #{tag[:key]}"
          end
        end
      end

      def save_suppliers_url
        # sample https://www.alibaba.com/access-tv-suppliers.html
        suppliers_urls_queue.process(false, TIMEOUT) do |suppliers_collection_url|
          suppliers = Pages::SuppliersList.new(suppliers_collection_url).suppliers
          suppliers.each do |supplier|
            suppliers_queue.push supplier[:href]
          end
          log :info, "Save #{suppliers.count} suppliers from #{suppliers_collection_url}"
        end
      end

      def save_suppliers
        suppliers_queue.process(false, TIMEOUT) do |supplier_url|
          page = Pages::Supplier.new(supplier_url)
          key = page.key
          redis.hmset "alibaba:#{key}",
                      'name', page.name,
                      'key', key,
                      'address', page.address,
                      'website', page.website,
                      'type', page.type,
                      'location', page.location,
                      'goods', page.goods,
                      'description', page.description,
                      'logo', page.logo
          redis.sadd SUPPLIERS_KEYS, key
          log :info, "Save #{key} supplier"
        end
      end

      def tags_list_urls_queue
        @tags_list_url_queue ||= Redis::Queue.new TAGS_LIST_URLS_QUEUE, "#{TAGS_LIST_URLS_QUEUE}_process", redis: redis
      end

      def tags_urls_queue
        @tags_url_queue ||= Redis::Queue.new TAGS_URLS_QUEUE, "#{TAGS_URLS_QUEUE}_process", redis: redis
      end

      def suppliers_urls_queue
        @suppliers_urls_queue ||= Redis::Queue.new SUPPLIERS_URLS_QUEUE, "#{SUPPLIERS_URLS_QUEUE}_process", redis: redis
      end

      def suppliers_queue
        @suppliers_queue ||= Redis::Queue.new SUPPLIERS_QUEUE, "#{SUPPLIERS_QUEUE}_process", redis: redis
      end

      alias tags save_suppliers_collection
      alias urls save_suppliers_url
      alias save save_suppliers
    end
  end
end
