class Client < ActiveRecord::Base
	validates :code, presence: true
	validates :company, presence: true

	has_many :sales_orders, :dependent => :destroy, autosave: true
	has_many :visit_windows, :dependent => :destroy, autosave: true

	has_many :client_visit_days, :dependent => :destroy, autosave: true
	has_many :client_item_desires, :dependent => :destroy, autosave: true

	belongs_to :price_tier

	has_many :item_prices, through: :price_tier

	# scope :created_before, ->(time) { where("created_at < ?", time) }
	# scope :scheduled_for_delivery_on, ->(day) { where("client_visit_days.day = ?", day)}

	# scope :scheduled_for_delivery_on, day {
  #   joins(:client_visit_days).where('companies.state' => "accepted")
  # }

	def has_sales_order_for_date? (date)
		SalesOrder.where(client:self, delivery_date:date).count > 0
	end

	scope :scheduled_for_delivery_on, ->(day) { where(:client_visit_days => {:day => day, :enabled => true}).joins(:client_visit_days).distinct }

	def price_for_item (item)
		match = item_prices
			.where(item:item)
			.first

		match.present? ? match.price : 0.0
	end


end
