class AddShippingColumnToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :shipping, :decimal, :null => false, :default => 0
  end
end
