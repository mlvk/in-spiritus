class OrderResource < JSONAPI::Resource
  attributes :delivery_date,
             :order_number,
             :xero_state,
             :order_type,
             :submitted_at

  filter     :delivery_date

  has_many   :order_items
  has_one    :location
  has_one    :fulfillment
end
