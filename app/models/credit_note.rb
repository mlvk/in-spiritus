class CreditNote < ActiveRecord::Base
  include AASM

  before_save :generate_credit_note_number

  aasm :credit_note, :column => :xero_state, :skip_validation_on_save => true do
    state :pending, :initial => true
    state :submitted
    state :synced
    state :voided

    event :mark_submitted do
      transitions :from => [:pending, :submitted, :synced], :to => :submitted
    end

    event :mark_synced do
      transitions :from => [:submitted, :synced], :to => :synced
    end

    event :void do
      transitions :from => [:pending, :submitted, :synced], :to => :voided
    end
  end

  enum xero_state: [ :pending, :submitted, :synced, :voided ]

  belongs_to :location

  has_one :fulfillment
  has_many :credit_note_items, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true
  has_many :notifications, dependent: :nullify, autosave: true

  scope :with_credit, -> {
    joins(:credit_note_items)
    .where('credit_note_items.quantity > ? AND credit_note_items.unit_price > ?', 0, 0)
    .distinct
  }

  def has_credit?
    credit_note_items.any? { |cni| cni.has_credit? }
  end

  def has_quantity?
    credit_note_items.any?(&:has_quantity?)
  end

  def is_valid?
    has_credit?
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
        self.credit_note_number = "CR-#{date.strftime('%y%m%d')}-#{SecureRandom.hex(2)}"
        save
      end
    end

    def generate_credit_note_number
      self.credit_note_number = "CR-#{date.strftime('%y%m%d')}-#{SecureRandom.hex(2)}"

      generate_credit_note_number unless valid_credit_note_number?
    end

    def valid_credit_note_number?
      match = CreditNote.find_by(credit_note_number: credit_note_number)
      (match.nil? || match == self) && credit_note_number.present?
    end
end
