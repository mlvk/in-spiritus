FactoryGirl.define do
  factory :notification do
    notification_rule

    trait :processed do
      notification_state { Notification.notification_states[:processed] }
    end

    factory :notification_invalid do
      renderer "SalesOrder"
    end

    factory :notification_with_sales_order do
      renderer "SalesOrder"
      order { create(:order, :sales_order) }
    end

    factory :notification_with_purchase_order do
      renderer "PurchaseOrder"
      order { create(:order, :purchase_order) }
    end

    factory :notification_with_fulfillment do
      renderer "Fulfillment"
      order { create(:fulfillment) }
    end

  end
end
