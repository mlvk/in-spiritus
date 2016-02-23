class OrderItem < ActiveRecord::Base
  belongs_to :order, touch: true
  belongs_to :item

  def self.find_by_date_location_item(date, location, item)
    OrderItem.joins(:order)
      .where(orders: { delivery_date: date, location_id: location.id })
      .where(item:item)
  end

end
