FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone { Faker::PhoneNumber.phone_number }
    password 'password'

    trait :admin do
      role { User.roles[:admin] }
    end

    trait :driver do
      role { User.roles[:driver] }
    end

    trait :accountant do
      role { User.roles[:accountant] }
    end
  end
end
