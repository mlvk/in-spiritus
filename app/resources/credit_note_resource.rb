class CreditNoteResource < JSONAPI::Resource
  attributes :date,
             :credit_note_number,
             :submitted_at

  filter     :date

  has_many   :credit_note_items
  has_one    :location
  has_one    :fulfillment
  has_many   :notifications
end
