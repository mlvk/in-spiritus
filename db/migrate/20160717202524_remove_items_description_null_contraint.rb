class RemoveItemsDescriptionNullContraint < ActiveRecord::Migration
  def change
    change_column :items, :description, :string, :null => true
  end
end
