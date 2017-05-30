# frozen_string_literal: false
module ApplicationHelper
  def host
    Rails.application.secrets.host
  end

  def stars(score, options = {})
    data = options.fetch(:data, {}).merge(score: score)
    classes = Array.wrap(options.fetch(:class, [])).push('stars-fa')
    content_tag :span, nil, data: data, class: classes
  end

  def square(options = {})
    classes = Array.wrap(options.fetch(:class, [])).push('square')
    out = content_tag :span, nil, class: classes
    if text = options[:text]
      out << content_tag(:span, text, class: 'ml-3')
    end
    out
  end

  def oauth_providers(activated)
    active_providers = activated.map &:provider
    out = ''
    OauthIdentity.provider.values.each do |provider|
      out << render(provider, data: activated.find { |o| o.provider == provider })
    end
    raw out
  end

  def metamagic_with_defaults
    metamagic \
      title: t('meta.defaults.title'),
      description: t('meta.defaults.description'),
      keywords: t('meta.defaults.keywords'),
      'og:title' => t('meta.defaults.title'),
      'og:type' => 'website',
      'og:url' => Rails.application.secrets.host,
      'og:description' => t('meta.defaults.description'),
      'og:image' => image_url('home-bg.jpg'),
      'twitter:card' => 'summary',
      'twitter:title' => t('meta.defaults.title'),
      'twitter:description' => t('meta.defaults.description')
  end
end
