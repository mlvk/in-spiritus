class AddNoteToLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :note, :text
  end
end
