class Location < ActiveRecord::Base
	belongs_to :company
	belongs_to :address
	has_many :orders, :dependent => :destroy, autosave: true
	has_many :credit_notes, :dependent => :destroy, autosave: true
	has_many :stocks, :dependent => :destroy, autosave: true

	has_many :visit_windows, :dependent => :destroy, autosave: true

	has_many :visit_days, :dependent => :destroy, autosave: true
	has_many :item_desires, :dependent => :destroy, autosave: true
	has_many :item_credit_rates, :dependent => :destroy, autosave: true

	scope :scheduled_for_delivery_on?, ->(day) { where(:visit_days => {:day => day-1, :enabled => true}).joins(:visit_days).distinct }

	def has_sales_order_for_date? (delivery_date)
		orders.where(delivery_date:delivery_date, order_type:'sales-order').present?
	end

	def full_name
		"#{code} - #{name}"
	end

end
