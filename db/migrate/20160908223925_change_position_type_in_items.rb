class ChangePositionTypeInItems < ActiveRecord::Migration[4.2]
  def change
    change_column :items, :position, :decimal, default: 0
  end
end
