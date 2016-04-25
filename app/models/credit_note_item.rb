class CreditNoteItem < ActiveRecord::Base
  belongs_to :credit_note, touch: true
  belongs_to :item

  def has_credit?
    (quantity * unit_price) > 0.0
  end
end
