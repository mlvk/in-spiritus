class SalesOrderItemResource < JSONAPI::Resource
  attributes :quantity, 
             :unit_price

  has_one :sales_order
  has_one :item
end
