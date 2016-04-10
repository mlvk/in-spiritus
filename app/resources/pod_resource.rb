class PodResource < JSONAPI::Resource
  attributes :signature,
             :name,
             :signed_at

  has_one :order
  has_one :user
end
