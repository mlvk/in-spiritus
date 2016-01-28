class PriceTierResource < JSONAPI::Resource
  attributes :name
  has_many :item_prices
  has_many :clients
end
