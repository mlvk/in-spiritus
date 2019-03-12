class RemoveItemsDescriptionNullContraint < ActiveRecord::Migration[4.2]
  def change
    change_column :items, :description, :string, :null => true
  end
end
