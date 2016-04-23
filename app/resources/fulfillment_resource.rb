class FulfillmentResource < JSONAPI::Resource
  attributes :fulfillment_state, :submitted_at

  has_one    :route_visit
  has_one    :stock
  has_one    :order
  has_one    :credit_note
  has_one    :pod
end
