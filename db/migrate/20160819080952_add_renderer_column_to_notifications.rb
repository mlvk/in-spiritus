class AddRendererColumnToNotifications < ActiveRecord::Migration[4.2]
  def change
    add_column :notifications, :renderer, :string, null: false, default: ""
  end
end
