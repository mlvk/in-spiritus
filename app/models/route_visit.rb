class RouteVisit < ActiveRecord::Base
	include AASM

	aasm :route_visit, :column => :route_visit_state, :skip_validation_on_save => true do
		state :pending, :initial => true
		state :fulfilled
		state :processed

		event :mark_fulfilled do
			transitions :from => [:pending, :processed, :fulfilled], :to => :fulfilled
		end

		event :mark_processed do
			transitions :from => :fulfilled, :to => :processed
		end
	end

	enum route_visit_state: [ :pending, :fulfilled, :processed ]

	belongs_to 	:route_plan
	belongs_to 	:address
	has_one 		:visit_windows, through: :address
	has_many 		:fulfillments, :dependent => :destroy, autosave: true
	has_many 		:orders, through: :fulfillments

	def is_valid?
		orders.any?(&:is_valid?)
	end

	def has_fulfillments?
		fulfillments.size > 0
	end

	def has_multiple_fulfillments?
		fulfillments.size > 1
	end

	def has_delivery?
		fulfillments
			.flat_map {|f| f.order}
			.any? {|o| o.sales_order?}
	end

	def has_pickup?
		fulfillments
			.flat_map {|f| f.order}
			.any? {|o| o.purchase_order?}
	end

	def has_route_plan?
		has_route_plan.present?
	end

	def to_string
		Maybe(fulfillments.first).order.to_string.fetch("")
	end
end
