class PodResource < JSONAPI::Resource
  attributes :signature,
             :name,
             :signed_at

  has_one    :user
  has_one    :fulfillment

end
