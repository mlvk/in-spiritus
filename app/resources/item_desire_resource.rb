class ItemDesireResource < JSONAPI::Resource
  attributes :desired
  has_one :location
  has_one :item
end
