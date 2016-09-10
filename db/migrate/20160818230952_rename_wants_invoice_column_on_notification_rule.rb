class RenameWantsInvoiceColumnOnNotificationRule < ActiveRecord::Migration
  def change
    rename_column :notification_rules, :wants_invoice, :wants_order
  end
end
