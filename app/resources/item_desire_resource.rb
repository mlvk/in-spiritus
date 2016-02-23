class ItemDesireResource < JSONAPI::Resource
  attributes :enabled
  has_one :location
  has_one :item
end
