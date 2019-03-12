FactoryBot.define do
  factory :notification_rule do
    email {ENV['FACTORY_NOTIFICATION_RULE_EMAIL']}
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    wants_credit {true}
    wants_order {true}
    location
    enabled {true}
  end
end
