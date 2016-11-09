class FulfillmentResource < JSONAPI::Resource
  attributes :delivery_state,
             :submitted_at

  has_one    :route_visit
  has_one    :stock
  has_one    :order
  has_one    :credit_note
  has_one    :pod

  filter :status, default: 'with_valid_order', apply: ->(records, value, _options) {
    records.joins(order: :order_items).where('order_items.quantity > ?', 0).distinct
  }

end
