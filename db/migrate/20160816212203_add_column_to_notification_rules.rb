class AddColumnToNotificationRules < ActiveRecord::Migration[4.2]
  def change
    add_column :notification_rules, :wants_invoice, :boolean, default: false, null: false
    add_column :notification_rules, :wants_credit, :boolean, default: false, null: false
  end
end
