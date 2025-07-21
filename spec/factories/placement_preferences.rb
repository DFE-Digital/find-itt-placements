FactoryBot.define do
  factory :placement_preference do
    trait :actively_looking do
      appetite { "actively_looking" }
    end

    trait :interested do
      appetite { "interested" }
    end

    trait :not_open do
      appetite { "not_open" }
    end

    association :academic_year, :current
    association :created_by, factory: :user
  end
end
