class ItemCreditRateResource < JSONAPI::Resource
  attributes :price
  has_one :location
  has_one :item
end
