class CreditNoteResource < JSONAPI::Resource
  attributes :date,
             :credit_note_number,
             :xero_state

  filter     :date

  has_many   :credit_note_items
  has_one    :location
  has_one    :fulfillment
end
