class Item < ActiveRecord::Base
	include AASM

	before_save :generate_item_code

	aasm :item, :column => :xero_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :synced

		event :mark_pending do
      transitions :from => :pending, :to => :pending
      transitions :from => :synced, :to => :pending
    end

    event :mark_synced do
      transitions :from => :pending, :to => :synced
      transitions :from => :synced, :to => :synced
    end
  end

	enum xero_state: [ :pending, :synced ]

	validates :name, :description, presence: true

	belongs_to	:company

	has_many 		:order_items, :dependent => :destroy, autosave: true
	has_many 		:item_prices, :dependent => :destroy, autosave: true
	has_many 		:item_credit_rates, :dependent => :destroy, autosave: true
	has_many 		:item_desires, :dependent => :destroy, autosave: true
	has_many 		:stock_levels, :dependent => :destroy, autosave: true

	scope :sold, -> { where(is_sold:true) }
	scope :purchased, -> { where(is_purchased:true) }

	def generate_item_code
		if code.nil?
			prefix = Maybe(company).initials.fetch('')
			new_code = "#{prefix} - #{SecureRandom.hex(3)}"
			update_attributes(code:new_code)
		end
	end
end
