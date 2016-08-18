class CreditNote < ActiveRecord::Base
  include AASM

  after_create :generate_credit_note_number

  aasm :credit_note, :column => :xero_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :submitted
    state :synced
    state :voided

    event :mark_submitted do
      transitions :from => :pending, :to => :submitted
      transitions :from => :synced, :to => :submitted
    end

    event :mark_synced do
      transitions :from => :submitted, :to => :synced
      transitions :from => :synced, :to => :synced
    end

    event :void do
      transitions :from => [:pending, :submitted, :synced], :to => :voided
    end
  end

  enum xero_state: [ :pending, :submitted, :synced, :voided ]

  belongs_to :location

  has_one :fulfillment, dependent: :nullify, autosave: true
  has_many :credit_note_items, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true
  has_many :notifications

  scope :with_credit, -> {
    joins(:credit_note_items)
    .where('credit_note_items.quantity > ? AND credit_note_items.unit_price > ?', 0, 0)
    .distinct
  }

  def fulfillment_id=(_value)
     # TODO: Remove once it's fixed
  end

  def fulfillment_id
    fulfillment.id
  end

  def has_credit?
    credit_note_items.any? { |cni| cni.has_credit? }
  end

  def total
    credit_note_items.inject(0) {|acc, cur| acc = acc + cur.total }
  end

  def renderer
    Pdf::CreditNote
  end

  private
    def generate_credit_note_number
      if self.credit_note_number.nil?
        self.credit_note_number = "CR-#{date.strftime('%y%m%d')}-#{SecureRandom.hex(5)}"
        save
      end
    end
end
