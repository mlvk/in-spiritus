class OrderItemResource < JSONAPI::Resource
  attributes :quantity,
             :unit_price

  has_one :order
  has_one :item
end
