class OrderItemResource < JSONAPI::Resource
  attributes :quantity,
             :unit_price

  has_one :order
  has_one :item

  after_save do
    @model.order.mark_submitted! if @model.order.synced?
  end

  after_remove do
    @model.order.mark_submitted! if @model.order.synced?
  end
end
