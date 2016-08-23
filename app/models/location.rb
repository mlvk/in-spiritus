class Location < ActiveRecord::Base

	before_save :pre_process_code

	belongs_to :company
	belongs_to :address

	has_many :orders
	has_many :credit_notes
	has_many :stocks

	has_many :notification_rules

	# has_many :visit_windows, :dependent => :destroy, autosave: true

	has_many :visit_days, :dependent => :destroy, autosave: true
	has_many :item_desires, :dependent => :destroy, autosave: true
	has_many :item_credit_rates, :dependent => :destroy, autosave: true

	scope :scheduled_for_delivery_on?, ->(day) { where(:visit_days => {:day => day-1, :enabled => true}).joins(:visit_days).distinct }

	def has_sales_order_for_date? (delivery_date)
		orders.where(delivery_date:delivery_date, order_type:'sales-order').present?
	end

	def has_valid_address?
		address.present?
	end

	scope :customer, -> { joins(:company).where(companies: {is_customer: true}) }
	scope :with_valid_address, -> { where("address_id IS NOT NULL") }

	def full_name
		"#{id} - #{name}"
	end

	private
	def pre_process_code
		generate_code unless has_code?
		self.code = self.code.downcase
	end
	def has_code?
		code.present?
	end

	def valid_code?(str)
		match = Location.find_by(code: str)
		(match.nil? || match == self) && str.present?
	end

	def generate_code(inc = 1)
		prefix = company.location_code_prefix
		num = inc.to_s.rjust(2, '0')
		str = "#{prefix}#{num}"
		self.code = str
		generate_code(inc + 1) unless valid_code?(str)
	end

end
