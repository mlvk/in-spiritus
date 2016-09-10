class AddRendererColumnToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :renderer, :string, null: false, default: ""
  end
end
