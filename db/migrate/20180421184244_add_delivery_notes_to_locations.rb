class AddDeliveryNotesToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :delivery_note, :text, :null => true
  end
end
