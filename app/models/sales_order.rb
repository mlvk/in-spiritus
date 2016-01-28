class SalesOrder < ActiveRecord::Base
  belongs_to :client
  has_many :sales_order_items, -> { joins(:item).order('position') }, :dependent => :destroy, autosave: true

  belongs_to :route_visit
end
