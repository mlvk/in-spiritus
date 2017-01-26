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
	has_many 		:credit_note_items, :dependent => :destroy, autosave: true
	has_many 		:item_prices, :dependent => :destroy, autosave: true
	has_many 		:item_credit_rates, :dependent => :destroy, autosave: true
	has_many 		:item_desires, :dependent => :destroy, autosave: true
	has_many 		:stock_levels, :dependent => :destroy, autosave: true

	scope :sold, -> { where(is_sold:true) }
	scope :purchased, -> { where(is_purchased:true) }

	scope :product, -> { where(tag:PRODUCT_TYPE)}
  scope :ingredient, -> { where(tag:INGREDIENT_TYPE)}

	scope :active, -> { where(active:true)}

	def financial_data_for_date_range(start_date, end_date)
		total_sales = order_items
			.joins(:order)
			.where("orders.delivery_date >= ?", start_date)
			.where("orders.delivery_date <= ?", end_date)
			.inject(0) { |acc, cur| acc = acc + cur.total }

		total_spoilage = credit_note_items
			.joins(:credit_note)
			.where("credit_notes.date >= ?", start_date)
			.where("credit_notes.date <= ?", end_date)
			.inject(0) { |acc, cur| acc = acc + cur.total }

    {
      id: id,
      name: name,
      total_sales: total_sales,
      total_spoilage: total_spoilage
    }
  end

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
