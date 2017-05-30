# frozen_string_literal: true
module Omniauthable
  def vkontakte(data, current_user)
    email = "#{data['uid']}#{rand(500)}@vkontakte.ru"
    transaction do
      identity = OauthIdentity.where(provider: :vkontakte, uid: data['uid']).first
      return link(identity, data, current_user) if current_user
      return identity.user if identity

      user = User.create \
        skip_password_validation: true,
        email: email,
        confirmed_at: Time.current
      OauthIdentity.create! \
        provider: :vkontakte,
        uid: data['uid'],
        user: user,
        data: data
      return user
    end
  end

  def facebook(data, current_user)
    email = data['info']['email']
    transaction do
      identity = OauthIdentity.where(provider: :facebook, uid: data['uid']).first
      return link(identity, data, current_user) if current_user
      return identity.user if identity

      user = User.create \
        skip_password_validation: true,
        email: email,
        confirmed_at: Time.now
      identity = create_identity user, data
      return user
    end
  end

  def twitter(data, current_user)
    email = "#{data['uid']}#{rand(500)}@twitter.com"
    transaction do
      identity = OauthIdentity.where(provider: :twitter, uid: data['uid']).first
      return link(identity, data, current_user) if current_user
      return identity.user if identity

      user = User.create \
        skip_password_validation: true,
        email: email,
        confirmed_at: Time.now
      identity = create_identity user, data
      return user
    end
  end

  private

  def link(identity, data, current_user)
    if identity.present?
      identity.update user: current_user, skip_password_validation: true
    else
      create_identity current_user, data
    end
    current_user
  end

  def create_identity(user, data)
    identity = OauthIdentity.create \
      provider: data['provider'],
      uid: data['uid'],
      user: user,
      data: data
  end
end
