class OrderResource < JSONAPI::Resource
  include XeroResource
  include XeroFinancialResource
  include SyncableResource
  include PublishableResource

  attributes :delivery_date,
             :order_number,
             :order_type,
             :submitted_at,
             :shipping,
             :internal_note,
             :comment

  filter     :delivery_date
  filter     :order_type

  has_many   :order_items
  has_one    :location
  has_one    :fulfillment
  has_many   :notifications
end
