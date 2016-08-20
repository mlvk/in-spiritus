FactoryGirl.define do
  factory :notification do
    notification_rule

    trait :processed do
      notification_state { Notification.notification_states[:processed] }
    end

    factory :notification_with_sales_order do
      renderer "UpdatedSalesOrder"
      order { create(:order, :sales_order) }
    end

    factory :notification_with_purchase_order do
      renderer "UpdatedPurchaseOrder"
      order { create(:order, :purchase_order) }
    end

    factory :notification_with_credit_note do
      renderer "UpdatedCreditNote"
      credit_note
    end
  end
end
