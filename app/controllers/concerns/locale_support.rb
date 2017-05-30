# frozen_string_literal: true
module LocaleSupport
  extend ActiveSupport::Concern

  included do
    before_action :set_locale
  end

  def set_locale
    session[:locale] = extract_locale || session[:locale]
    I18n.locale = session[:locale] || I18n.default_locale
  end

  private

  def extract_locale
    parsed_locale = params[:locale] || request.subdomains.first
    locale_name = case parsed_locale
                  when 'zh-cn'
                    'zh-CN'
                  else
                    parsed_locale
                  end
    I18n.available_locales.map(&:to_s).include?(locale_name) ? locale_name : nil
  end
end
