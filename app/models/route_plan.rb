class RoutePlan < ActiveRecord::Base
	include AASM

	aasm :route_plan, :column => :published_state, :skip_validation_on_save => true do
    state :draft, :initial => true
    state :published
		state :completed

    event :mark_draft do
      transitions :from => :published, :to => :draft
			transitions :from => :completed, :to => :draft
    end

		event :mark_published do
      transitions :from => :draft, :to => :published
			transitions :from => :completed, :to => :published
    end

		event :mark_completed do
      transitions :from => :published, :to => :completed
			transitions :from => :draft, :to => :completed
    end
  end

  # State machine settings
  enum published_state: [ :draft, :published, :completed ]

	belongs_to :user
	has_many :route_visits, :dependent => :nullify, autosave: true

	def renderer
    Pdf::RoutePlan
  end

	default_scope { order 'date DESC' }
end
