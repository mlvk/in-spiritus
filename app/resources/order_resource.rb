class OrderResource < JSONAPI::Resource
  attributes :delivery_date,
             :order_number,
             :xero_state,
             :order_type,
             :submitted_at,
             :notification_state,
             :shipping

  filter     :delivery_date
  filter     :order_type

  has_many   :order_items
  has_one    :location
  has_one    :fulfillment
  has_many   :notifications
end
