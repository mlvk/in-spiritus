class SalesOrderItem < ActiveRecord::Base
  belongs_to :sales_order, touch: true
  belongs_to :item

  def self.find_by_date_client_item(date, client, item)
    SalesOrderItem.joins(:sales_order)
      .where(sales_orders: { delivery_date: date, client_id: client.id })
      .where(item:item)
  end

end
