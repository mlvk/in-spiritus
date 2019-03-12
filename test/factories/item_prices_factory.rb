FactoryBot.define do
  factory :item_price do
    price { Faker::Commerce.price }
  end
end
