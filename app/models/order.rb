class Order < ActiveRecord::Base
  include AASM

  after_create :generate_order_number

  # State machine settings
  enum xero_state: [ :pending, :fulfilled, :synced, :voided ]

  aasm :order, :column => :xero_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :fulfilled
    state :synced
    state :voided

    event :mark_fulfilled do
      transitions :from => :pending, :to => :fulfilled
    end

    event :mark_synced do
      transitions :from => :synced, :to => :synced
      transitions :from => :fulfilled, :to => :synced
    end

    event :void do
      transitions :from => [:pending, :fulfilled, :synced], :to => :voided
    end
  end

  enum notifications_state: [ :unprocessed, :processed ]
  aasm :notifications, :column => :notifications_state, :skip_validation_on_save => true, :no_direct_assignment => true do
    state :unprocessed, :initial => true
    state :processed

    event :process do
      transitions :from => :unprocessed, :to => :processed
    end
  end

  belongs_to :location
  has_one :fulfillment, dependent: :nullify, autosave: true
  has_many :order_items, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true

  def fulfillment_id=(_value)
     # TODO: Remove once it's fixed
  end

  def fulfillment_id
    fulfillment.id
  end

  private
    def generate_order_number
      self.order_number = "OR-#{delivery_date.strftime('%y%m%d')}-#{id}"
      save
    end
end
