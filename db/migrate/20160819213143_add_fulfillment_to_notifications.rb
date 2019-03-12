class AddFulfillmentToNotifications < ActiveRecord::Migration[4.2]
  def change
    add_reference :notifications, :fulfillment, index: true, foreign_key: true
  end
end
