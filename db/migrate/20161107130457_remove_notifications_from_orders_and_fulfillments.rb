class RemoveNotificationsFromOrdersAndFulfillments < ActiveRecord::Migration[4.2]
  def up
    remove_column :orders, :notification_state
    remove_column :fulfillments, :notification_state
  end

  def down
    add_column :orders, :notification_state, :integer, default: 0, null: false
    add_column :fulfillments, :notification_state, :integer, default: 0, null: false
  end
end
