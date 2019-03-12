FactoryBot.define do
  factory :order do
    delivery_date { Date.tomorrow }
    location

    trait :synced do
      sync_state { Order.sync_states[:synced] }
    end

    trait :submitted do
      xero_financial_record_state { Order.xero_financial_record_states[:submitted] }
    end

    trait :authorized do
      xero_financial_record_state { Order.xero_financial_record_states[:authorized] }
    end

    trait :voided do
      xero_financial_record_state { Order.xero_financial_record_states[:voided] }
    end

    trait :deleted do
      xero_financial_record_state { Order.xero_financial_record_states[:deleted] }
    end

    trait :with_xero_id do
      xero_id { SecureRandom.hex(10) }
    end

    trait :purchase_order do
      order_type {Order::PURCHASE_ORDER_TYPE}
    end

    trait :sales_order do
      order_type {Order::SALES_ORDER_TYPE}
    end

    factory :order_with_items do
      transient do
        items {nil}
        order_items_count {5}
      end

      after(:create) do |order, evaluator|
        if evaluator.items.present?
          evaluator.items.each do |item|
            create(:order_item, order: order, item:item)
          end
        else
          create_list(:order_item, evaluator.order_items_count, order: order)
        end
      end
    end

    factory :sales_order_with_items do
      order_type {Order::SALES_ORDER_TYPE}

      transient do
        items {nil}
        order_items_count {5}
      end

      after(:create) do |order, evaluator|
        if evaluator.items.present?
          evaluator.items.each do |item|
            create(:order_item, order: order, item:item)
          end
        else
          create_list(:order_item, evaluator.order_items_count, order: order)
        end
      end
    end

    factory :purchase_order_with_items do
      order_type {Order::PURCHASE_ORDER_TYPE}

      transient do
        order_items_count {5}
      end

      after(:create) do |order, evaluator|
        create_list(:order_item, evaluator.order_items_count, order: order)
      end
    end

  end
end
