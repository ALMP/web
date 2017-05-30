# frozen_string_literal: true
class OauthIdentity < ApplicationRecord
  extend Enumerize

  belongs_to :user

  enumerize :provider, in: %i(vkontakte facebook twitter)
end
