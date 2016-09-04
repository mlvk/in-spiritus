FactoryGirl.define do
  factory :fulfillment do
    route_visit
    pod
    association :order, factory: :order_with_items
    association :credit_note, factory: :credit_note_with_credit_note_items

    trait :fulfilled do
      delivery_state { Fulfillment.delivery_states[:fulfilled] }
    end

    trait :processed do
      delivery_state { Fulfillment.delivery_states[:processed] }
    end

    factory :fulfillment_with_notification_rule do
      after(:create) do |fulfillment, evaluator|
        create(:notification_rule, location: fulfillment.order.location)
      end
    end

  end
end
