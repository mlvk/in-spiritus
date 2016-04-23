class StockLevelResource < JSONAPI::Resource
  attributes :starting,
             :returns,
             :tracking_state

  has_one    :stock
  has_one    :item
end
