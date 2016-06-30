class AddShippingColumnToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping, :decimal, :null => false, :default => 0
  end
end
