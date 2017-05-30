# frozen_string_literal: true
class PurchasePrice < ApplicationRecord
  extend Enumerize
  include Approvable
  include Companies::Assignable

  belongs_to :user
  belongs_to :company

  validates :name, :company_id, :kind, :unit, :value_cents, :value_currency, :quantity, :status, presence: true
  validates :quantity, :value, numericality: { greater_than_or_equal_to: 0 }

  monetize :value_cents

  enumerize :kind, in: [:goods, :work, :service], default: :goods
  enumerize :unit, in: [:item, :meter, :long_meter, :kg, :liter, :carat, :pound, :ounce, :foot, :inch, :gallon, :cubic_meter, :hour, :day, :project], default: :item

  def volume
    "#{quantity}#{unit.text}"
  end
end
