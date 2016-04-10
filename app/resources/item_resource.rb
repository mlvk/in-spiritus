class ItemResource < JSONAPI::Resource
  attributes :name,
             :description,
             :tag,
             :position,
             :xero_state

  has_many :order_items
end
