class NotificationResource < JSONAPI::Resource
  attributes :processed_at,
             :notification_state

  has_one :order
  has_one :credit_note
  has_one :notification_rule
end
