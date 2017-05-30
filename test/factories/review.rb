# frozen_string_literal: true
FactoryGirl.define do
  factory :review do
    sequence(:name) { |index| "review-#{index}" }
    company
    user
    rating { 1 }
    service { 0 }
    quality { 0 }
    payments { 0 }
    stability { 0 }
    fairness { 0 }
    recommended { false }
    thankful { false }
    advantages { 'adv ' * 60 }
    disadvantages { 'disadv ' * 60 }
    recommendations { 'reccom' * 60 }
    terms_of_use_confirmed { true }
  end
end
