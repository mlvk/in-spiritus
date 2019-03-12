class UpdateItemAndCompanyAasmStates < ActiveRecord::Migration[4.2]
  def up
    add_column :items, :sync_state, :integer, default: 0, null: false
    add_index :items, :sync_state

    add_column :companies, :sync_state, :integer, default: 0, null: false
    add_index :companies, :sync_state

    Item.all.each {|i| i.mark_synced!}
    Company.all.each {|c| c.mark_synced!}

    remove_column :items, :xero_state
    remove_column :companies, :xero_state
  end

  def down
    add_column :items, :xero_state, :integer, default: 0, null: false
    add_index :items, :xero_state

    add_column :companies, :xero_state, :integer, default: 0, null: false
    add_index :companies, :xero_state

    Item.all.each {|i| i.update_column(:xero_state, 1)}
    Company.all.each {|c| c.update_column(:xero_state, 1)}

    remove_column :items, :sync_state
    remove_column :companies, :sync_state
  end
end
