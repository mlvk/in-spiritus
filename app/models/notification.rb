class Notification < ActiveRecord::Base
  include AASM

  aasm :notification, :column => :notification_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :processed

    event :mark_pending do
      transitions :from => [:pending, :processed], :to => :pending
    end

    event :mark_processed do
      transitions :from => [:pending, :processed], :to => :processed
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

  def has_fulfillment?
    !fulfillment.nil?
  end

  def has_documents?
    has_order? || has_credit? || has_fulfillment?
  end

  def build_message
    Maybe("Renderers::#{renderer}").constantize.new.render(self).fetch()
  end
end
