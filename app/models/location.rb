class Location < ActiveRecord::Base
	# validates :name, presence: true

	before_save :pre_process_code

	belongs_to :company
	belongs_to :address

	has_many :orders, :dependent => :destroy, autosave: true
	has_many :credit_notes, :dependent => :destroy, autosave: true
	has_many :stocks, :dependent => :destroy, autosave: true

	has_many :notification_rules, :dependent => :destroy, autosave: true

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
		generate_code unless valid_code?
		self.code = code.downcase
	end

	def valid_code?
		match = Location.find_by(code: code)
		(match.nil? || match == self) && code.present?
	end

	def generate_code(inc = 1)
		prefix = company.location_code_prefix
		num = inc.to_s.rjust(2, '0')
		self.code = "#{prefix}#{num}".downcase

		generate_code(inc + 1) unless valid_code?
	end

end
