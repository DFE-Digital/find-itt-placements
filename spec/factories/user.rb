FactoryBot.define do
  factory :user do
    first_name { "Judith" }
    last_name { "Chicken" }
    sequence(:email_address) { |n| "judith.chicken#{n}@hogwarts.sch.uk" }
    dfe_sign_in_uid { SecureRandom.uuid }
  end
end
