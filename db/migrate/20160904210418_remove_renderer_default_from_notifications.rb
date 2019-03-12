class RemoveRendererDefaultFromNotifications < ActiveRecord::Migration[4.2]
  def change
    change_column_default(:notifications, :renderer, nil)
  end
end
