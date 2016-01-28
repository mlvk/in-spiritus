class Item < ActiveRecord::Base
	validates :code, presence: true

	has_many :sales_order_items, :dependent => :destroy, autosave: true
	has_many :item_price_tiers, :dependent => :destroy, autosave: true
	has_many :client_item_desires, :dependent => :destroy, autosave: true
end
