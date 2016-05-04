class ItemResource < JSONAPI::Resource
  attributes :name,
             :description,
             :tag,
             :position,
             :xero_state

  has_many :order_items
  has_many :credit_note_items
  has_many :item_desires
  has_many :item_price
  has_many :item_credit_rates
  has_many :stocks

  before_save do
    @model.xero_state = Item.xero_states[:pending]
  end
end
