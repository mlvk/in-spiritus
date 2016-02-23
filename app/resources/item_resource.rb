class ItemResource < JSONAPI::Resource
  attributes :name,
             :description,
             :tag,
             :position

  has_many :order_items
end
