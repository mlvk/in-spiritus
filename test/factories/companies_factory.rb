FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    terms 7
  end
end
