class ItemPriceResource < JSONAPI::Resource
  attributes :price
  has_one :price_tier
  has_one :item
end
