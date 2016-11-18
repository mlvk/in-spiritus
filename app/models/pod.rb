class Pod < ActiveRecord::Base
  belongs_to :user
  has_one :fulfillment
end
