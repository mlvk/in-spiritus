class CreditNoteItem < ActiveRecord::Base
  belongs_to :credit_note, touch: true, optional: true
  belongs_to :item, optional: true

  def has_quantity?
    quantity > 0.0
  end

  def has_credit?
    total > 0.0
  end

  def total
    quantity * unit_price
  end
end
