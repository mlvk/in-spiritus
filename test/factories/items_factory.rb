FactoryGirl.define do
  factory :item do
    code { SecureRandom.hex(3) }
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
    default_price { Faker::Commerce.price }

    trait :synced do
      xero_state { Item.xero_states[:synced] }
      xero_id { SecureRandom.hex(10) }
    end
  end
end
