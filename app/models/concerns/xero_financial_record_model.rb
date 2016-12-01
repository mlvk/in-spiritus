module XeroFinancialRecordModel
  extend ActiveSupport::Concern

  VALID_STATES = [:draft, :submitted, :authorized, :paid, :billed]

  XERO_STATUS_MAPPING = {
    draft: "DRAFT",
    submitted: "SUBMITTED",
    authorized: "AUTHORISED",
    paid: "PAID",
    billed: "BILLED",
    deleted: "DELETED",
    voided: "VOIDED"
  }

  included do
    include AASM

    aasm :xero_financial_record_state, :column => :xero_financial_record_state, :skip_validation_on_save => true do
      state :draft, :initial => true
      state :submitted
      state :authorized
      state :paid
      state :billed
      state :deleted
      state :voided

      event :mark_draft do
        transitions :from => [:draft, :submitted], :to => :draft
      end

      event :mark_submitted do
        transitions :from => [:draft, :submitted], :to => :submitted
      end

      event :mark_authorized do
        transitions :from => [:draft, :submitted, :authorized], :to => :authorized
      end

      event :mark_paid do
        transitions :from => [:draft, :submitted, :authorized, :paid], :to => :paid
      end

      event :mark_billed do
        transitions :from => [:draft, :submitted, :authorized, :billed], :to => :billed
      end

      event :mark_deleted do
        transitions :from => [:draft, :submitted, :deleted], :to => :deleted
      end

      event :mark_voided do
        transitions :from => [:voided, :authorized], :to => :voided
      end
    end

    enum xero_financial_record_state: [ :draft, :submitted, :authorized, :paid, :billed, :deleted, :voided ]
  end

  def xero_status_code
    key = aasm(:xero_financial_record_state).current_state
    XERO_STATUS_MAPPING[key]
  end

  def valid_state?
    VALID_STATES.any? { |state| state == aasm(:xero_financial_record_state).current_state }
  end

  def sync_with_xero_status(status)
    case status
    when 'DRAFT'
      mark_draft!
    when 'SUBMITTED'
      mark_submitted!
    when 'AUTHORISED'
      mark_authorized!
    when 'PAID'
      mark_paid!
    when 'BILLED'
      mark_billed!
    when 'DELETED'
      mark_deleted!
    when 'VOIDED'
      mark_voided!
    end
  end
end
