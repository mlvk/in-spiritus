FactoryGirl.define do
  factory :location do
    name 'Some Name'
    code 'eb001'
    company
    address

    trait :synced do
      xero_state { Location.xero_state[:synced] }
    end
  end
end
