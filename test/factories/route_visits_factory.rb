FactoryGirl.define do
  factory :route_visit do
    position 1
    route_plan
    address
    date { Date.today}

    trait :pending do
      route_visit_state { RouteVisit.route_visit_states[:pending] }
    end

    trait :fulfilled do
      route_visit_state { RouteVisit.route_visit_states[:fulfilled] }
    end

    trait :processed do
      route_visit_state { RouteVisit.route_visit_states[:processed] }
    end

    factory :route_visit_with_unfulfilled_fulfillments do
      transient do
        fulfillment_count 5
      end

      after(:create) do |route_visit, evaluator|
        create_list(:fulfillment, evaluator.fulfillment_count, route_visit: route_visit)
      end
    end

    factory :route_visit_with_fulfilled_fulfillments do
      transient do
        fulfillment_count 1
      end

      after(:create) do |route_visit, evaluator|
        create_list(:fulfillment_with_notification_rule, evaluator.fulfillment_count, :fulfilled, route_visit: route_visit)
      end
    end
  end
end
