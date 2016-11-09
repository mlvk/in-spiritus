class Fulfillment < ActiveRecord::Base
  include AASM

  aasm :fulfillment, :column => :delivery_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :fulfilled
    state :processed

    event :mark_fulfilled do
      transitions :from => [:pending, :fulfilled, :processed], :to => :fulfilled
    end

    event :mark_processed do
      transitions :from => :fulfilled, :to => :processed
    end
  end

  enum delivery_state: [ :pending, :fulfilled, :processed ]

  belongs_to :route_visit
  belongs_to :order
  belongs_to :stock
  belongs_to :pod
  belongs_to :credit_note
  has_many   :notifications, dependent: :nullify, autosave: true

  has_one :location, through: :order

  scope :belongs_to_sales_order, -> { joins(:order).where(orders: {order_type: Order::SALES_ORDER_TYPE}) }

  def has_processed_notification?
    notifications.processed.present?
  end

  def has_pending_notification?
    notifications.pending.present?
  end

  def never_notified?
    notifications.empty?
  end

  def has_valid_order?
    order.is_valid?
  end

  def is_valid?
    order.is_valid? || credit_note.is_valid?
  end
end
