FactoryGirl.define do
  factory :location do
    name { Faker::Address.city }
    company
    address

    trait :synced do
      xero_state { Location.xero_state[:synced] }
    end
  end
end
