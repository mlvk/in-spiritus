class RouteVisit < ActiveRecord::Base
	include AASM

	aasm :route_visit, :column => :route_visit_state, :skip_validation_on_save => true do
		state :pending, :initial => true
		state :fulfilled

		event :mark_fulfilled do
			transitions :from => :pending, :to => :fulfilled
		end
	end

	enum route_visit_state: [ :pending, :fulfilled ]

	belongs_to 	:route_plan
	belongs_to 	:address
	has_one 		:visit_windows, through: :address
	has_many 		:fulfillments, :dependent => :destroy, autosave: true
	has_many 		:orders, through: :fulfillments
end
