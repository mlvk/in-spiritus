class Pod < ActiveRecord::Base
  belongs_to :user
  has_one :fulfillment, dependent: :nullify, autosave: true

  def fulfillment_id=(_value)
     # TODO: Remove once it's fixed
  end

  def fulfillment_id
    fulfillment.id
  end

end
