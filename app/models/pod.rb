class Pod < ActiveRecord::Base
  belongs_to :user, optional: true
  has_one :fulfillment
end
