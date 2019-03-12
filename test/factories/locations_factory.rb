FactoryBot.define do
  factory :location do
    name { Faker::Address.city }
    company
    address

    transient do
      order_count {0}
      credit_note_count {0}
      stock_count {0}
      notification_rule_count {0}
      visit_day_count {0}
      item_desire_count {0}
      item_credit_rate_count {0}
    end

    trait :synced do
      xero_state { Location.xero_state[:synced] }
    end

    after(:create) do |location, evaluator|

      create_list(:order,
        evaluator.order_count,
        location: location) if evaluator.order_count != 0

      create_list(:credit_note,
        evaluator.credit_note_count,
        location: location) if evaluator.credit_note_count != 0

      create_list(:stock,
        evaluator.stock_count,
        location: location) if evaluator.stock_count != 0

      create_list(:notification_rule,
        evaluator.notification_rule_count,
        location: location) if evaluator.notification_rule_count != 0

      create_list(:visit_day,
        evaluator.visit_day_count,
        location: location) if evaluator.visit_day_count != 0

      create_list(:item_desire,
        evaluator.item_desire_count,
        location: location) if evaluator.item_desire_count != 0

      item = Item.all.sample
      item = create(:item) if item.nil?
      create_list(:item_credit_rate,
        evaluator.item_credit_rate_count,
        location: location,
        item:Item.all.sample) if evaluator.item_credit_rate_count != 0
    end
  end
end
