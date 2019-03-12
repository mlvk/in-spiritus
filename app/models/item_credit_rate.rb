class ItemCreditRate < ActiveRecord::Base
  belongs_to :location, optional: true
  belongs_to :item, optional: true
end
