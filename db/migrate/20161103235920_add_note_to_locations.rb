class AddNoteToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :note, :text
  end
end
