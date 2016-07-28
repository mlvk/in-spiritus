FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    terms 7

    trait :synced do
      xero_state { Company.xero_states[:synced] }
      xero_id { SecureRandom.hex(10) }
    end

    factory :companies_with_locations do
      transient do
        location_count 5
      end

      after(:create) do |company, evaluator|
        create_list(:location, evaluator.location_count, company: company)
      end

      before(:create) do |company, evaluator|
        company.price_tier = PriceTier.all.sample
      end
    end
  end
end
