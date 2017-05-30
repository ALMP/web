# frozen_string_literal: true
FactoryGirl.define do
  factory :company do
    sequence(:name) { |index| "company-#{index}" }
    url 'url.company.com'
    phone '555-1-555'
    email
    zipcode '222750'
    address 'Pushkina 4, 12'
    description 'Product description'
  end
end
