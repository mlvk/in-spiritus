class StockLevel < ActiveRecord::Base
  validates :quantity, :item, presence: true
  validates :quantity, numericality: true

  belongs_to :stock
  belongs_to :item
end
