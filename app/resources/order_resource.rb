class OrderResource < JSONAPI::Resource
  attributes :delivery_date,
             :invoiced,
             :fullfilled,
             :voided,
             :signature,
             :order_type

  filter :delivery_date

  has_many :order_items
  has_one :location
  has_one :route_visit
end
