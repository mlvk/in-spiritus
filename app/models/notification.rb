class Notification < ActiveRecord::Base
  include AASM

  aasm :notification, :column => :notification_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :processed

    event :mark_pending do
      transitions :from => :pending, :to => :pending
      transitions :from => :processed, :to => :pending
    end

    event :mark_processed do
      transitions :from => :pending, :to => :processed
      transitions :from => :processed, :to => :processed
    end
  end

  # State machine
  enum notification_state: [ :pending, :processed ]

  belongs_to :order
  belongs_to :credit_note
  belongs_to :fulfillment
  belongs_to :notification_rule

  def has_order?
    !order.nil?
  end

  def has_credit?
    !credit_note.nil?
  end

  def build_message
    Maybe(renderer).constantize.new.render(self).fetch()
  end
end
