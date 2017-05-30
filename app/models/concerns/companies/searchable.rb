# frozen_string_literal: true
module Companies
  module Searchable
    extend ActiveSupport::Concern
    include PgSearch

    included do
      pg_search_scope :autocomplete,
                      associated_against: {
                        company_aliases: [
                          %w(name A)
                        ]
                      },
                      against: {
                        name: 'B'
                      },
                      using:
                      {
                        tsearch: { prefix: true }
                      }

      pg_search_scope :term_russian,
                      associated_against: {
                        company_aliases: [
                          %w(name A)
                        ]
                      },
                      against: {
                        name: 'B'
                      },
                      using: {
                        tsearch: {
                          dictionary: 'russian'
                        }
                      }

      pg_search_scope :term_english,
                      associated_against: {
                        company_aliases: [
                          %w(name A)
                        ]
                      },
                      against: {
                        name: 'B'
                      },
                      using: {
                        tsearch: {
                          dictionary: 'english'
                        }
                      }

      pg_search_scope :term_simple,
                      associated_against: {
                        company_aliases: [
                          %w(name A)
                        ]
                      },
                      against: {
                        name: 'B'
                      },
                      using: {
                        tsearch: {
                          dictionary: 'simple'
                        }
                      }

      scope :term, lambda { |query, language = Globalize.locale|
        scopes = {
          'ru' => term_russian(query),
          'en' => term_english(query)
        }
        scopes[language.to_s] || term_simple(query)
      }
    end
  end
end
