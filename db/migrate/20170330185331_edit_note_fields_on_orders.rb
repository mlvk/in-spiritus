class EditNoteFieldsOnOrders < ActiveRecord::Migration
  def up
    rename_column :orders, :note, :internal_note
    add_column :orders, :comment, :string
  end

  def down
    rename_column :orders, :internal_note, :note
    remove_column :orders, :comment
  end
end
