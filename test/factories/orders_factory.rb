FactoryGirl.define do
  factory :order do
    delivery_date { Date.tomorrow }
    location

    trait :pending do
      xero_state { Order.xero_states[:pending] }
    end

    trait :submitted do
      xero_state { Order.xero_states[:submitted] }
    end

    trait :synced do
      xero_state { Order.xero_states[:synced] }
      xero_id { SecureRandom.hex(10) }
    end

    trait :purchase_order do
      order_type Order::PURCHASE_ORDER_TYPE
    end

    trait :sales_order do
      order_type Order::SALES_ORDER_TYPE
    end

    factory :sales_order_with_items do
      order_type Order::SALES_ORDER_TYPE

      transient do
        order_items_count 5
      end

      after(:create) do |order, evaluator|
        create_list(:order_item, evaluator.order_items_count, order: order)
      end
    end

  end
end
