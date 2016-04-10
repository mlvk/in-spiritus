class CreditNoteItemResource < JSONAPI::Resource
  attributes :quantity,
             :unit_price

  has_one :credit_note
  has_one :item
end
