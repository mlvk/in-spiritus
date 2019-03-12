class RoutePlan < ActiveRecord::Base
	include AASM

	aasm :route_plan, :column => :published_state, :skip_validation_on_save => true do
    state :pending, :initial => true
		state :completed

    event :mark_pending do
			transitions :from => [:completed, :pending], :to => :pending
    end

		event :mark_completed do
      transitions :from => [:completed, :pending], :to => :completed
    end
  end

  # State machine settings
  enum published_state: [ :pending, :completed ]

	belongs_to :user, optional: true
	has_many :route_visits, -> { order('position') }, :dependent => :nullify, autosave: true

	def renderer
    Pdf::RoutePlan
  end

	default_scope { order 'date DESC' }

	def delivery_visits
		route_visits.select {|rv| rv.has_delivery?}
	end

	def pickup_visits
		route_visits.select {|rv| rv.has_pickup?}
	end
end
