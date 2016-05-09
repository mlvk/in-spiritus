FactoryGirl.define do
  factory :notification_rule do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    location
    enabled true
  end
end
