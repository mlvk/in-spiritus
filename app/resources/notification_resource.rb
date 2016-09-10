class NotificationResource < JSONAPI::Resource
  attributes :processed_at,
             :notification_state,
             :renderer

  has_one :order
  has_one :credit_note
  has_one :fulfillment
  has_one :notification_rule
end
