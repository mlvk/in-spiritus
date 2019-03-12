class AddNoteToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :note, :text
  end
end
