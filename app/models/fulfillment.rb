class Fulfillment < ActiveRecord::Base
  include AASM

  # State machine settings
  enum fulfillment_state: [ :pending, :fulfilled ]

  aasm :fulfillment, :column => :fulfillment_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :fulfilled

    event :mark_fulfilled do
      transitions :from => :pending, :to => :fulfilled
    end
  end

  belongs_to :route_visit
  belongs_to :order
  belongs_to :stock
  belongs_to :pod
  belongs_to :credit_note
end
