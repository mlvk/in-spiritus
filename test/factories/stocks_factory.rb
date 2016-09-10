FactoryGirl.define do
  factory :stock do
    day_of_week 1
    taken_at Date.tomorrow
  end
end
