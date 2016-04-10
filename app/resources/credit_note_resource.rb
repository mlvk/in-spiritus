class CreditNoteResource < JSONAPI::Resource
  attributes :date,
             :credit_note_number,
             :xero_state,
             :notifications_state

  filter :date

  has_many :credit_note_items
  has_one  :location
end
