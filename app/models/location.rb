class Location < ActiveRecord::Base
	belongs_to :company

	has_many :sales_orders, :dependent => :destroy, autosave: true
	has_many :visit_windows, :dependent => :destroy, autosave: true

	has_many :visit_days, :dependent => :destroy, autosave: true
	has_many :item_desires, :dependent => :destroy, autosave: true

	belongs_to :address

	scope :scheduled_for_delivery_on, ->(day) { where(:visit_days => {:day => day, :enabled => true}).joins(:visit_days).distinct }
end
