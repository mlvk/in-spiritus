class ChangeShippingV2 < ActiveRecord::Migration[4.2]
  def change
    change_column :orders, :shipping, :decimal, :null => true
  end
end
