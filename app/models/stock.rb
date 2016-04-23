class Stock < ActiveRecord::Base

  validates :location, presence: true

  has_one :fulfillment, dependent: :nullify, autosave: true
  belongs_to :location

  def fulfillment_id=(_value)
     # TODO: Remove once it's fixed
  end

  def fulfillment_id
    fulfillment.id
  end

  has_many :stock_levels, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true
end
