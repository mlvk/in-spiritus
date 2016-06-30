class ChangeShippingV2 < ActiveRecord::Migration
  def change
    change_column :orders, :shipping, :decimal, :null => true
  end
end
