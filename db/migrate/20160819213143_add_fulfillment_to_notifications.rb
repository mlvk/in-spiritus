class AddFulfillmentToNotifications < ActiveRecord::Migration
  def change
    add_reference :notifications, :fulfillment, index: true, foreign_key: true
  end
end
