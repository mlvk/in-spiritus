FactoryGirl.define do
  factory :company do
    is_customer true
    is_vendor false
    name { Faker::Company.name }
    terms 7
    active_state 0
    price_tier

    trait :inactive do
      active_state 1
    end

    trait :synced do
      sync_state { Company.sync_states[:synced] }
    end

    trait :with_xero_id do
      xero_id { SecureRandom.hex(10) }
    end

    trait :vendor do
      is_customer false
      is_vendor true
    end

    factory :company_with_locations do
      transient do
        location_count 3
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
