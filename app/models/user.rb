# frozen_string_literal: true
class User < ApplicationRecord
  attr_accessor :skip_password_validation

  devise :database_authenticatable, :trackable, :rememberable, :recoverable,
         :registerable, :validatable,
         :omniauthable, omniauth_providers: [:vkontakte, :facebook, :twitter]

  extend Enumerize
  extend Omniauthable
  include PgSearch

  pg_search_scope :autocomplete,
                  against: %i(email),
                  using:
                  {
                    tsearch: { prefix: true }
                  }

  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 8 }, allow_blank: true

  has_many :oauth_identities, dependent: :destroy
  has_many :reviews, dependent: :nullify
  has_many :purchase_prices, dependent: :nullify

  enumerize :type, in: [:AdminUser, :User]

  def admin?
    false
  end

  def invited_users
    # User.where(recommendator: email.strip)
    User.all
  end

  def name
    email
  end

  def self.ransackable_scopes(auth_object = nil)
    super + %w(autocomplete)
  end

  def password_required?
    # binding.pry
    return false if skip_password_validation
    return false if persisted? && has_no_password?
    super
  end

  # allow password update without current password
  def update_without_password(params, *options)
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def has_no_password?
    encrypted_password.blank?
  end
end
