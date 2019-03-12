FactoryBot.define do
  factory :price_tier do
    sequence(:name) { |n| "Price List - #{n}" }
    transient do
      items {[]}
    end

    after(:create) do |price_tier, evaluator|
      evaluator.items.each do |item|
        create(:item_price, price_tier: price_tier, item: item, price: 1.0)
      end
    end

  end
end
