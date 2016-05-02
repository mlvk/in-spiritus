FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
    code { Faker::Code.ean }
    terms 7
  end
end
