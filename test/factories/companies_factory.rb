FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    terms 7

    trait :synced do
      xero_state { Company.xero_states[:synced] }
      xero_id { SecureRandom.hex(10) }
    end
  end
end
