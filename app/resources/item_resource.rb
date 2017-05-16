class ItemResource < JSONAPI::Resource
  include XeroResource
  include SyncableResource

  attributes :name,
             :code,
             :description,
             :unit_of_measure,
             :tag,
             :position,
             :is_purchased,
             :is_sold,
             :default_price,
             :active

  has_many :order_items
  has_many :order_template_items
  has_many :credit_note_items
  has_many :item_desires
  has_many :item_prices
  has_many :item_credit_rates
  has_many :stocks
  has_one  :company

  filters :tag,
          :is_sold,
          :is_purchased,
          :company_id,
          :active
end
