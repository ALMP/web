# frozen_string_literal: true

require 'uri'

class CompanyPresenter < ApplicationPresenter
  DIVIDER = '/'
  NA = '-'
  COMMA = ', '

  def details
    [url, source.city&.name]
      .select(&:present?)
      .join(" #{DIVIDER} ")
  end

  def phone
    source.phone.presence || NA
  end

  def email
    source.email.presence || NA
  end

  def address
    source.address.presence || NA
  end

  def zipcode
    source.zipcode.presence || NA
  end

  def categories
    return NA if source.categories.empty?
    source.categories.includes(:translations).map(&:name).join(COMMA)
  end

  def city
    source.city&.name || NA
  end

  def goods
    return NA if source.goods.empty?
    source.goods.includes(:translations).map(&:name).join(COMMA)
  end

  def url
    URI.parse(URI.encode(source.url.to_s)).host
  end

  def to_structured_data(url: nil)
    result = {
      '@context' => 'http://schema.org',
      '@type' => 'Organization',
      'url' => url,
      'name' => name,
      'aggregateRating' => {
        '@type' => 'AggregateRating',
        'ratingValue' => rating.to_f,
        'reviewCount' => confirmed_reviews_count
      }
    }
    result['sameAs'] = source.url if source.url.present?

    if source.phone.present?
      result['contactPoint'] = [{
        '@type' => 'ContactPoint',
        'telephone' => source.phone,
        'contactType' => 'customer service'
      }]
    end

    result['areaServed'] = source.city.name if source.city.present?
    result['address'] = source.address if source.address.present?
    result['description'] = source.description if source.description.present?
    result.to_json
  end
end
