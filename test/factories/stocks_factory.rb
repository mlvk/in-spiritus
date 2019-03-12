FactoryBot.define do
  factory :stock do
    day_of_week {1}
    taken_at {Date.tomorrow}
    location

    factory :stock_with_stock_levels do
      transient do
        items {nil}
        stock_level_count {5}
      end

      after(:create) do |stock, evaluator|
        if evaluator.items.present?
          evaluator.items.each do |item|
            create(:stock_level, stock: stock, item:item)
          end
        else
          create_list(:stock_level, evaluator.stock_level_count, stock: stock)
        end
      end
    end
  end
end
