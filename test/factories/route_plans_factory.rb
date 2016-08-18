FactoryGirl.define do
  factory :route_plan do
    date { Date.tomorrow }
    user

    trait :published do
      published_state RoutePlan.published_states[:published]
    end
  end
end
