class Stock < ActiveRecord::Base

  validates :location, presence: true

  has_one :fulfillment
  belongs_to :location

  has_many :stock_levels, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true
end
