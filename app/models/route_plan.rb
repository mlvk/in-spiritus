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

	belongs_to :user
	has_many :route_visits, :dependent => :nullify, autosave: true

	def renderer
    Pdf::RoutePlan
  end

	default_scope { order 'date DESC' }
end
