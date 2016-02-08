class ItemResource < JSONAPI::Resource
  attributes :code,
             :description,
             :tag,
             :position

  has_many :sales_order_items
end
