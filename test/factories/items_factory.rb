FactoryGirl.define do
  factory :item do
    code { SecureRandom.hex(3) }
    name { Faker::Commerce.product_name }

    company

    trait :synced do
      xero_state { Item.xero_states[:synced] }
      xero_id { SecureRandom.hex(10) }
    end
  end
end
