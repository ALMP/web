# frozen_string_literal: true
FactoryGirl.define do
  sequence :email do |index|
    "email#{index}@example.com"
  end

  factory :user do
    email
    password 'user1234567'
  end

  factory :admin_user do
    email
    password 'admin1234567'
  end
end
