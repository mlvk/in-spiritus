class ChangeShippingColumn < ActiveRecord::Migration[4.2]
  def change
    change_column :orders, :shipping, :decimal, :null => false
  end
end
