class ItemPrice < ActiveRecord::Base
  belongs_to :item, optional: true
  belongs_to :price_tier, optional: true

  default_scope {joins(:item).order('items.position')}
end
