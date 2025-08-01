FactoryBot.define do
  factory :placement_subject do
    sequence(:code, "AA")
    phase { %i[primary secondary].sample }

    trait :secondary do
      phase { :secondary }
    end
  end
end
