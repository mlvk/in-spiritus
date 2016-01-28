class CreditItem < ActiveRecord::Base
  belongs_to :credit, touch: true
  belongs_to :item
end
