# frozen_string_literal: true
require 'nokogiri'

class TranslateController < ApplicationController
  def index
    bing_response = http.get "#{uri.path}?#{bing_params.to_query}", bing_headers
    @response = Nokogiri::HTML.parse(bing_response.body).text
    render text: @response
  end

  private

  def http
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http
  end

  def uri
    @uri ||= URI.parse('https://api.microsofttranslator.com/v2/http.svc/Translate')
  end

  def token
    Translator.token
  end

  def authorization
    "Bearer #{token['access_token']}"
  end

  def bing_params
    {
      text: params[:text],
      to: locales[params[:to]]
    }
  end

  def locales
    {
      'en-US' => 'en',
      'en' => 'en',
      'ru' => 'ru',
      'zh-CN' => 'zh-CHS'
    }
  end

  def bing_headers
    {
      'Authorization' => authorization
    }
  end
end
