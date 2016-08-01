class RouteVisitResource < JSONAPI::Resource
  attributes  :arrive_at,
              :depart_at,
              :position,
              :date,
              :route_visit_state,
              :completed_at

  attribute   :fulfillment_count
  attribute   :has_pickup
  attribute   :has_drop

  has_one     :route_plan
  has_one     :address

  has_many    :fulfillments

  filter      :date

  filter :status, default: 'with_valid_orders', apply: ->(records, value, _options) {
    records.joins(orders: :order_items).where('order_items.quantity > ?', 0).distinct
  }

  filter :has_route_plan, apply: ->(records, value, _options) {
    if value
      records.where(route_plan_id: nil)
    else
      records.where.not(route_plan_id: nil)
    end
  }

  def records_for_fulfillments
    @model.fulfillments.joins(order: :order_items).where('order_items.quantity > ?', 0).distinct
  end

  def fulfillment_count
    @model.fulfillments.count
  end

  def has_pickup
    @model.fulfillments.any? {|f| f.order.sales_order?}
  end

  def has_drop
    @model.fulfillments.any? {|f| f.order.purchase_order?}
  end
end
