class RouteVisitResource < JSONAPI::Resource
  attributes  :arrive_at,
              :depart_at,
              :position,
              :date

  has_one :route_plan
  has_one :address

  has_many  :fulfillments

  filter    :date

  filter :status, default: 'with_valid_orders', apply: ->(records, value, _options) {
    records.joins(orders: :order_items).where('order_items.quantity > ?', 0).distinct
  }
end


 # RouteVisit.joins(fulfillments: :order).where(orders: {id: 40}).first
