# frozen_string_literal: true
FactoryGirl.define do
  factory :category do
    sequence(:name_en)  { |i| "Category-#{i}" }
    sequence(:name_ru)  { |i| "Категория-#{i}" }
    sequence(:name_zh_cn) { |i| "Category-zh-cn-#{i}" }
  end
end
