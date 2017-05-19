class Location < ActiveRecord::Base
	include StringUtils

	before_save :pre_process_saving_data

	belongs_to :company
	belongs_to :address

	has_many :orders, :dependent => :destroy, autosave: true
	has_many :order_templates, :dependent => :destroy, autosave: true
	has_many :order_template_days, through: :order_templates
	has_many :credit_notes, :dependent => :destroy, autosave: true
	has_many :stocks, :dependent => :destroy, autosave: true

	has_many :notification_rules, :dependent => :destroy, autosave: true

	has_many :visit_days, :dependent => :destroy, autosave: true
	has_many :item_desires, :dependent => :destroy, autosave: true
	has_many :item_credit_rates, :dependent => :destroy, autosave: true

	def has_sales_order_for_date? (delivery_date)
		orders.where(delivery_date:delivery_date, order_type:'sales-order').present?
	end

	def has_valid_address?
		address.present?
	end

	scope :scheduled_for_delivery_on?, ->(delivery_date) {
		day = delivery_date.cwday - 1

		find_by_sql " SELECT DISTINCT locations.* FROM locations
			INNER JOIN companies ON companies.id = locations.company_id
			LEFT OUTER JOIN order_templates ON order_templates.location_id = locations.id
			LEFT OUTER JOIN order_template_days ON order_template_days.order_template_id = order_templates.id
			LEFT OUTER JOIN visit_days ON visit_days.location_id = locations.id
				WHERE (
					(
						visit_days.day = #{day}
						AND
						visit_days.enabled = true
						AND
						locations.active = true
						AND
						companies.active_state = #{Company.active_states[:active]}
						AND
						companies.is_customer = true
						AND
						locations.address_id IS NOT NULL
					)
					OR
					(
						order_template_days.day = #{day}
						AND
						order_template_days.enabled = true
						AND
						locations.active = true
						AND
						companies.active_state = #{Company.active_states[:active]}
						AND
						companies.is_customer = true
						AND
						locations.address_id IS NOT NULL
					)
				)"
	}

	scope :customer, -> { joins(:company).where(companies: {is_customer: true}) }
	scope :with_valid_address, -> { where("address_id IS NOT NULL") }
	scope :active, -> {
		joins(:company)
			.where(companies: {active_state: Company.active_states[:active]})
			.where(active: true)
	}

	def full_name
		"#{code} - #{name}"
	end

	def stock_levels_for_item(item)
		StockLevel
			.joins(:stock)
			.where(stocks: {location_id: id})
			.order("stocks.taken_at DESC")
			.where(item_id: item.id)
	end

	def previous_stock_level(stock_level)
		stock_levels_for_item(stock_level.item)
			.where("stocks.taken_at < ?", stock_level.stock.taken_at)
			.first
	end

	def financial_data_for_date_range(start_date, end_date)
		orders = Order
			.where("delivery_date >= ?", start_date)
			.where("delivery_date <= ?", end_date)
			.where("location_id = ?", id)
			.sales_order
			.select { |o| o.is_valid? }
			.select { |o| !o.draft? }

		raw_data = orders.map { |o|
			{
				date: o.delivery_date,
				total_sale: o.total_sale,
				shipping: o.shipping,
				stock: o.fulfillment.stock.returns_data,
				credit: o.fulfillment.credit_note.credit_data
			}
		}

		total_sales_revenue = raw_data.inject(0) { |acc, cur| acc = acc + cur[:total_sale] }
		total_dist_revenue = raw_data.inject(0) { |acc, cur| acc = acc + cur[:shipping] }
		total_spoilage = raw_data.inject(0) { |acc, cur| acc = acc + cur[:credit][:total_credit] }

		{
			id: id,
			name: name,
			total_sales_revenue: total_sales_revenue,
			total_dist_revenue: total_dist_revenue,
			total_spoilage: total_spoilage,
			raw_data: raw_data
		}
	end

	private
	def pre_process_saving_data
		# Generate location code
		self.code = trim_and_downcase code
		generate_code unless valid_code?

		# trim data
    self.name = trim name
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
