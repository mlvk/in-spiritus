class StockLevelResource < JSONAPI::Resource
  attributes :quantity

  has_one :stock
  has_one :item
end
