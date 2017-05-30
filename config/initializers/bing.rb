# frozen_string_literal: true
COGNITIVE_ACCESS_TOKEN_URI = 'https://api.cognitive.microsoft.com/sts/v1.0/issueToken'

module Translator
  cattr_accessor :client

  def self.secrets
    Rails.application.secrets.bing
  end

  def self.token
    @token ||= _token
    @token = _token if Time.current > @token['expires_at']
    @token
  end

  def self._token
    cognitive_token_uri = URI.parse(COGNITIVE_ACCESS_TOKEN_URI)
    headers = { 'Ocp-Apim-Subscription-Key' => secrets['first_key'] }
    http = Net::HTTP.new(cognitive_token_uri.host, cognitive_token_uri.port)
    http.use_ssl = true
    response = http.post(cognitive_token_uri.path, '', headers)
    {
      'access_token' => response.body,
      'expires_at' => Time.current + 540
    }
  end
end
