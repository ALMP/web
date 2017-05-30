# frozen_string_literal: true
FactoryGirl.define do
  factory :good do
    sequence(:name_en)  { |i| "Good-#{i}" }
    sequence(:name_ru)  { |i| "Товар-#{i}" }
    sequence(:name_zh_cn) { |i| "Good-zh-cn-#{i}" }
  end
end
