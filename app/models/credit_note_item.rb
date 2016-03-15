class CreditNoteItem < ActiveRecord::Base
  belongs_to :credit_note, touch: true
  belongs_to :item
end
