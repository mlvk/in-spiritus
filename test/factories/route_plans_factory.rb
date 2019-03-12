FactoryBot.define do
  factory :route_plan do
    date { Date.tomorrow }
    user
  end
end
