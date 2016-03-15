class Item < ActiveRecord::Base
	validates :name, presence: true

	has_many :order_items, :dependent => :destroy, autosave: true
	has_many :item_prices, :dependent => :destroy, autosave: true
	has_many :item_desires, :dependent => :destroy, autosave: true
end
