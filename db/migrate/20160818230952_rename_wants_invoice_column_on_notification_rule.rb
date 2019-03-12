class RenameWantsInvoiceColumnOnNotificationRule < ActiveRecord::Migration[4.2]
  def change
    rename_column :notification_rules, :wants_invoice, :wants_order
  end
end
