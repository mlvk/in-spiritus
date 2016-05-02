class StockLevel < ActiveRecord::Base
  include AASM

  validates :starting, :returns, :item, presence: true
  validates :starting, :returns, numericality: true

  aasm :stock_level, :column => :tracking_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :tracked
    state :processed

    event :mark_tracked do
      transitions :from => :pending, :to => :tracked
    end

    event :mark_pending do
      transitions :from => :tracked, :to => :pending
    end

    event :mark_processed do
      transitions :from => :tracked, :to => :processed
    end
  end

  enum tracking_state: [ :pending, :tracked, :processed ]

  belongs_to :stock
  belongs_to :item
end
