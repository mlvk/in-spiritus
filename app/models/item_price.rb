class ItemPrice < ActiveRecord::Base
  belongs_to :item
  belongs_to :price_tier

  default_scope {joins(:item).order('items.position')}
end
