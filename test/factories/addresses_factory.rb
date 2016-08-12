ADDRESSES = [
  [34.136902,-118.271252],
  [34.093013,-118.300018],
  [34.081456,-118.308965],
  [34.081181,-118.31286],
  [34.043884,-118.341708],
  [33.962088,-118.394232],
  [33.908533,-118.369197],
  [33.876836,-118.3876404],
  [33.88577,-118.396459],
  [33.890838,-118.401952],
  [33.889413,-118.2600771],
  [33.904638,-118.1911296],
  [33.909348,-118.186484],
  [33.91266,-118.186838],
  [33.921997,-118.182984],
  [33.942824,-118.1441075],
  [33.946001,-118.141651],
  [33.768023,-118.1737104],
  [33.758421,-118.1415712],
  [34.01851,-118.498712],
  [34.021701,-118.5039461]
]

FactoryGirl.define do
  factory :address do
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    sequence :lat do |n|
      index = n % ADDRESSES.size
      ADDRESSES[index].first
    end
    sequence :lng do |n|
      index = n % ADDRESSES.size
      ADDRESSES[index].last
    end
  end
end
