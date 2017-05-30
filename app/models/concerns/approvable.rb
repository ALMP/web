# frozen_string_literal: true
module Approvable
  extend ActiveSupport::Concern

  included do
    enumerize :status, in: [:pending, :confirmed, :declined], default: :pending, scope: true, predicate: true
    scope :confirmed, -> { where(status: :confirmed) }
  end
end
