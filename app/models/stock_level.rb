class StockLevel < ActiveRecord::Base
  include AASM

  validates :starting, :returns, :item, presence: true
  validates :starting, :returns, numericality: true

  aasm :stock_level, :column => :tracking_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :tracked
    state :processed

    event :mark_pending do
      transitions :from => :tracked, :to => :pending
    end

    event :mark_tracked do
      transitions :from => [:pending, :tracked, :processed], :to => :tracked
    end

    event :mark_processed do
      transitions :from => :tracked, :to => :processed
    end
  end

  enum tracking_state: [ :pending, :tracked, :processed ]

  belongs_to :stock, optional: true
  belongs_to :item, optional: true
  has_one :fulfillment, through: :stock

  scope :fulfillment_fulfilled, -> { joins(:fulfillment).where(fulfillments: {delivery_state: Fulfillment.delivery_states[:fulfilled]}) }
  scope :fulfillment_processed, -> { joins(:fulfillment).where(fulfillments: {delivery_state: Fulfillment.delivery_states[:processed]}) }

  def ending_level
    order = Maybe(stock).fulfillment.order.fetch(nil)
    dropped = Maybe(order).quantity_of_item(item).fetch(0)

    [starting + dropped - returns, 0].max
  end

  def has_starting?
    starting > 0.0
  end

  def has_returns?
    returns > 0.0
  end
end
