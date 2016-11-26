FactoryGirl.define do
  factory :item do
    code { SecureRandom.hex(3) }
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    default_price { Faker::Commerce.price }
    position {  Faker::Number.decimal(2) }

    trait :synced do
      sync_state { Company.sync_states[:synced] }
    end

    trait :with_xero_id do
      xero_id { SecureRandom.hex(10) }
    end

    trait :product do
      tag Item::PRODUCT_TYPE
    end
  end
end
