class AddColumnToNotificationRules < ActiveRecord::Migration
  def change
    add_column :notification_rules, :wants_invoice, :boolean, default: false, null: false
    add_column :notification_rules, :wants_credit, :boolean, default: false, null: false
  end
end
