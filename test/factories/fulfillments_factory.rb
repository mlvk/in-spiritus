FactoryGirl.define do
  factory :fulfillment do
    route_visit
    order
    credit_note
    pod

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
