class AddOrderStateToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :order_state, :integer, default: 0, null: false
  end
end
