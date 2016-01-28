class ClientItemDesireResource < JSONAPI::Resource
  attributes :desired
  has_one :client
  has_one :item
end
