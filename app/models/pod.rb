class Pod < ActiveRecord::Base
  belongs_to :order
  belongs_to :user
  has_one :fulfillment, dependent: :nullify, autosave: true
end
