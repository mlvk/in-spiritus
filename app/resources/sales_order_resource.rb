class SalesOrderResource < JSONAPI::Resource
  attributes :delivery_date, :invoiced, :fullfilled, :voided, :signature
  filter :delivery_date

  has_many :sales_order_items
  has_one :client
  has_one :route_visit
end
