FactoryBot.define do
  factory :organisation do
    factory :school, class: School do
      type { "School" }
      name { "Hogwarts" }
      sequence(:urn) { _1 }

      trait :with_placement_preferences do
        after(:create) do |school|
          create(:placement_preference, organisation: school, academic_year: AcademicYear.next)
        end
      end
    end

    factory :provider, class: Provider do
      type { "Provider" }
      name { "Order of the Phoenix" }
      sequence(:code) { _1 }
    end
  end
end
