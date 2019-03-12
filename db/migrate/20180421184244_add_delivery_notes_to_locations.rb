class AddDeliveryNotesToLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :delivery_note, :text, :null => true
  end
end
