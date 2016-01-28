class ItemResource < JSONAPI::Resource
  attributes :sku, :code, :description, :shelf_life, :position
  has_many :sales_order_items
end
