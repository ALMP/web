# frozen_string_literal: true
class Review < ApplicationRecord
  extend Enumerize
  include Paginatable
  include Approvable
  include Companies::Assignable

  belongs_to :company
  belongs_to :user
  has_one :custom_rating

  validates :name, presence: true
  validates :advantages, :disadvantages,
            length: { minimum: 50 },
            allow_blank: true
  validates :quality, :payments, :service, :stability, :fairness,
            numericality: { greater_than_or_equal_to: 0, only_integer: true, less_than_or_equal_to: 5 },
            allow_nil: true

  validates :advantages, :disadvantages, :terms_of_use_confirmed, presence: true

  enumerize :category,
            in: %i(current_buyer former_buyer potential_buyer operating_officer former_employee),
            default: :current_buyer

  scope :recommended, -> { where(recommended: true) }
  scope :thankful, -> { where(thankful: true) }
  scope :last_week, -> { where('reviews.created_at > ?', 1.week.ago) }

  after_touch :reload_company_rating, if: :company
  after_save :reload_company_rating, if: :company
  before_save :calculate_rating
  after_destroy :reload_company_rating, if: :company
  after_update :reload_company_rating, if: :company_id_was

  accepts_nested_attributes_for :custom_rating, allow_destroy: true, reject_if: proc { |attrs| attrs['title'].blank? }

  def with_text?
    advantages.present? || disadvantages.present? || recommendations.present?
  end

  def with_questions?
    recommended? || thankful?
  end

  private

  def calculate_rating
    values = [quality.to_i, payments.to_i, service.to_i, stability.to_i, fairness.to_i, custom_rating&.value.to_i].select do |value|
      value > 0
    end
    self.rating = values.any? ? values.sum.to_f / values.count : 0
    true
  end

  def reload_company_rating
    company.reload_rating!
    Company.find(company_id_was).reload_rating! if company_id_was
  end
end
