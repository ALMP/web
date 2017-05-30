# frozen_string_literal: true
module Paginatable
  extend ActiveSupport::Concern

  module ClassMethods
    def pagination_interval
      from = current_scope.offset_value + 1
      to = from + current_scope.limit_value - 1
      to = current_scope.total_count if current_scope.last_page?
      (from...to)
    end
  end
end

module Kaminari
  module ActionViewExtension
    def page_entries_info(collection, options = {})
      no_entries = options[:no_entries]

      entry_name = if options[:entry_name]
                     options[:entry_name].pluralize(collection.total_count, I18n.locale)
                   else
                     # Fix for correct pluralisation: when we have at least 2 pages, we need the name to be as :many
                     # field in locale. 10 stands for it.
                     collection.model_name.human(count: collection.total_pages > 1 ? 10 : collection.total_count)
                   end
      entry_name = entry_name.mb_chars.downcase.to_s unless collection.total_count.zero?

      if collection.total_pages < 2
        if collection.total_count.zero? && !no_entries.nil?
          t(no_entries)
        else
          t('helpers.page_entries_info.one_page.display_entries', entry_name: entry_name, count: collection.total_count)
        end
      else
        first = collection.offset_value + 1
        last = [collection.offset_value + collection.limit_value, collection.total_count].min
        total = collection.total_count
        t('helpers.page_entries_info.more_pages.display_entries', entry_name: entry_name, first: first, last: last, total: total)
      end.html_safe
    end
  end
end
