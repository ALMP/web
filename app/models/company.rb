# frozen_string_literal: true
class Company < ApplicationRecord
  include Paginatable
  include Companies::Searchable

  default_scope -> { includes(:aggregated_rating) }

  validates :name, uniqueness: true, presence: true
  validates :email, email: true, allow_blank: true
  validates :phone, phone: true, allow_blank: true
  validates :external_key, uniqueness: true, allow_blank: true
  validates :zipcode, numericality: { only_integer: true }, allow_blank: true

  mount_uploader :logo, LogoUploader

  has_and_belongs_to_many :goods
  has_and_belongs_to_many :categories
  has_one :aggregated_rating, dependent: :destroy
  has_many :company_aliases, dependent: :destroy
  has_many :purchase_prices
  belongs_to :city
  has_many :city_translations, through: :city, source: :translations
  has_many :goods_translations, through: :goods, source: :translations
  has_many :categories_translations, through: :categories, source: :translations
  has_many :reviews, dependent: :nullify
  has_many :publications, dependent: :nullify
  has_one :last_review, -> { confirmed.order(created_at: :desc) }, class_name: 'Review'
  has_many :confirmed_reviews, -> { confirmed }, class_name: 'Review'
  has_many :confirmed_publications, -> { confirmed }, class_name: 'Publication'
  has_many :weekly_reviews, -> { confirmed.last_week }, class_name: 'Review'
  has_many :confirmed_custom_ratings, through: :confirmed_reviews, source: :custom_rating

  after_create :create_aggregated_rating

  accepts_nested_attributes_for :company_aliases, allow_destroy: true, reject_if: proc { |attrs| attrs['name'].blank? }

  delegate \
    :confirmed_reviews_count,
    :rating,
    :recommended,
    :thankful,
    :quality,
    :payments,
    :stability,
    :fairness,
    :service,
    :other,
    to: :aggregated_rating

  scope :with_city_name, lambda {
    select('companies.*,
           COALESCE(city_translations.name, cities.fallback_locale_name) as city_name')
      .joins("
           LEFT OUTER JOIN cities ON cities.id = companies.city_id
           LEFT OUTER JOIN city_translations ON city_translations.city_id = cities.id
             AND city_translations.locale = '#{Globalize.locale}'
          ")
  }

  scope :popular, lambda {
    select('companies.*, count(reviews.id) AS reviews_count')
      .joins(:weekly_reviews)
      .group('companies.id')
      .order('reviews_count DESC NULLS LAST')
  }

  # rubocop:disable LineLength
  ransack_alias :q,
                :name_or_categories_translations_name_or_goods_translations_name_or_url_or_phone_or_city_translations_name_or_address_or_zipcode_or_company_aliases_name

  ransacker :city_name do
    Arel.sql('city_name')
  end

  def ransackable_associations
    %w(city_translations goods_translations categories_translations aggregated_rating)
  end

  def self.ransackable_scopes(auth_object = nil)
    super + %w(term autocomplete popular)
  end

  def aliases
    company_aliases.map(&:name).join(', ')
  end

  def reload_rating!
    reviews_scope = reviews.confirmed
    update \
      last_review_added: reviews_scope.maximum('created_at')
    aggregated_rating.update \
      confirmed_reviews_count: reviews_scope.count,
      rating: (reviews_scope.average(:rating) || 0),
      quality: (reviews_scope.where('quality > 0').average(:quality) || 0),
      fairness: (reviews_scope.where('fairness > 0').average(:fairness) || 0),
      payments: (reviews_scope.where('payments > 0').average(:payments) || 0),
      stability: (reviews_scope.where('stability > 0').average(:stability) || 0),
      service: (reviews_scope.where('service > 0').average(:service) || 0),
      thankful: (reviews_scope.average('case when thankful then 1 else 0 end') || 0),
      recommended: (reviews_scope.average('case when recommended then 1 else 0 end') || 0),
      other: (confirmed_custom_ratings.where('value > 0').average(:value) || 0)
  end
end
