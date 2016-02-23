class Order < ActiveRecord::Base
  belongs_to :location
  has_many :order_items, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true

  belongs_to :route_visit
end
