class Stock < ActiveRecord::Base

  validates :location, presence: true

  has_one :fulfillment
  belongs_to :location

  has_many :stock_levels, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true

  def returns_data
    stock_levels
      .select { |sl| sl.has_returns? }
      .map { |sl| {item:"#{sl.item.code} - #{sl.item.name}", quantity: sl.returns} }
  end
end
