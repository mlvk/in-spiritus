class Item < ActiveRecord::Base
	include XeroRecord
	include SyncableModel
	include StringUtils

	PRODUCT_TYPE = 'product'
  INGREDIENT_TYPE = 'ingredient'

	before_save :clean_fields

	validates :name, presence: true

	belongs_to	:company

	has_many 		:order_items, :dependent => :destroy, autosave: true
	has_many 		:item_prices, :dependent => :destroy, autosave: true
	has_many 		:item_credit_rates, :dependent => :destroy, autosave: true
	has_many 		:item_desires, :dependent => :destroy, autosave: true
	has_many 		:stock_levels, :dependent => :destroy, autosave: true

	scope :sold, -> { where(is_sold:true) }
	scope :purchased, -> { where(is_purchased:true) }

	scope :product, -> { where(tag:PRODUCT_TYPE)}
  scope :ingredient, -> { where(tag:INGREDIENT_TYPE)}

	private
	def clean_fields
		if code.nil?
			initials = Maybe(company).initials
			prefix = initials.empty? ? "" : "#{initials.fetch()} - "
			new_code = "#{prefix}#{SecureRandom.hex(3)}"
			update_attributes(code:new_code)
		end

		# trim data
    self.code = trim code
		self.name = trim name
	end
end
