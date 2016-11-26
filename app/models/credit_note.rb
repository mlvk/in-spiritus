class CreditNote < ActiveRecord::Base
  include SyncableModel
  include XeroRecord
  include XeroFinancialRecordModel

  before_save :generate_credit_note_number

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
