class CreditNote < ActiveRecord::Base
  include AASM

  after_create :generate_credit_note_number

  belongs_to :location
  has_many :credit_note_items, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true
  belongs_to :route_visit

  # State machine settings
  enum credit_note_state: [ :submitted, :synced, :voided ]
  enum notifications_state: [ :unprocessed, :processed ]

  aasm :credit_note, :column => :credit_note_state, :skip_validation_on_save => true, :no_direct_assignment => true do
    state :submitted, :initial => true
    state :synced
    state :voided

    event :mark_synced do
      transitions :from => :submitted, :to => :synced
      transitions :from => :synced, :to => :synced
    end

    event :void do
      transitions :from => [:submitted, :synced], :to => :voided
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
    def generate_credit_note_number
      self.credit_note_number = "CR-#{date.strftime('%y%m%d')}-#{id}"
      save
    end
end
