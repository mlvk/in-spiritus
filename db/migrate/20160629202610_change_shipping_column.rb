class ChangeShippingColumn < ActiveRecord::Migration
  def change
    change_column :orders, :shipping, :decimal, :null => false
  end
end
