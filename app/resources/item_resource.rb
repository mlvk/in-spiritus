class ItemResource < JSONAPI::Resource
  attributes :name,
             :code,
             :description,
             :tag,
             :position,
             :xero_state,
             :is_purchased,
             :is_sold,
             :default_price

  has_many :order_items
  has_many :credit_note_items
  has_many :item_desires
  has_many :item_price
  has_many :item_credit_rates
  has_many :stocks
  has_one  :company

  filter :tag
  filter :is_sold
  filter :is_purchased

  before_save do
    @model.xero_state = Item.xero_states[:pending]
  end
end
