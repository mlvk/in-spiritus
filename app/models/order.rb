class Order < ActiveRecord::Base
  include AASM

  after_create :generate_invoice_number

  belongs_to :location
  has_many :order_items, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true
  belongs_to :route_visit

  # State machine settings
  enum order_state: [ :pending, :fulfilled, :synced, :voided ]
  enum notifications_state: [ :unprocessed, :processed ]

  aasm :order, :column => :order_state, :skip_validation_on_save => true, :no_direct_assignment => true do
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

  aasm :notifications, :column => :notifications_state, :skip_validation_on_save => true, :no_direct_assignment => true do
    state :unprocessed, :initial => true
    state :processed

    event :process do
      transitions :from => :unprocessed, :to => :processed
    end
  end

  private
    def generate_invoice_number
      self.order_number = "INV-#{delivery_date.strftime('%y%m%d')}-#{id}"
      save
    end
end
