class RemoveRendererDefaultFromNotifications < ActiveRecord::Migration
  def change
    change_column_default(:notifications, :renderer, nil)
  end
end
