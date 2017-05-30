# frozen_string_literal: true
module Companies
  module TranslatableDictionary
    extend ActiveSupport::Concern
    include PgSearch

    included do
      translates :name

      globalize_accessors locales: I18n.available_locales, attributes: [:name]

      validates :"name_#{I18n.default_locale}", presence: true
      validate :name_presence

      default_scope -> { includes(:translations) }

      before_save :set_fallback_locale_name

      pg_search_scope :autocomplete,
                      associated_against:
                      {
                        translations: [:name]
                      },
                      using:
                      {
                        tsearch: { prefix: true }
                      }
    end

    def cache_key
      super + '-' + Globalize.locale.to_s
    end

    def set_fallback_locale_name
      fallback_locale = I18n.default_locale
      self.fallback_locale_name = public_send("name_#{fallback_locale}")
    end

    def name_presence
      errors.add :name, :blank if public_send("name_#{I18n.default_locale}").blank?
    end

    def as_json(options = {})
      super options.reverse_merge(methods: self.class.globalize_attribute_names, except: :fallback_locale_name)
    end

    module ClassMethods
      def ransackable_scopes(auth_object = nil)
        super + %w(autocomplete)
      end
    end
  end
end
