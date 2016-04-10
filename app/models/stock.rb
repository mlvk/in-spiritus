class Stock < ActiveRecord::Base
  validates :location, :taken_at, :day_of_week, presence: true

  has_one :fulfillment, dependent: :nullify, autosave: true
  has_many :stock_levels, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true
end
