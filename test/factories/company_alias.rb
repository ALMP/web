# frozen_string_literal: true
FactoryGirl.define do
  factory :company_alias do
    company
    name 'alias'
  end
end
