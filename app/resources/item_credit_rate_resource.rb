class ItemCreditRateResource < JSONAPI::Resource
  attributes :rate
  has_one :location
  has_one :item
end
