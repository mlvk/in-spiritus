class ChangePositionTypeInItems < ActiveRecord::Migration
  def change
    change_column :items, :position, :decimal, default: 0
  end
end
