class SalesOrderItem < ActiveRecord::Base
  belongs_to :sales_order, touch: true
  belongs_to :item

  def self.find_by_date_location_item(date, location, item)
    SalesOrderItem.joins(:sales_order)
      .where(sales_orders: { delivery_date: date, location_id: location.id })
      .where(item:item)
  end

end
