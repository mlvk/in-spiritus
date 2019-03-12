class AddAasmStateColumnsToModels < ActiveRecord::Migration[4.2]
  def up
    add_column :orders, :published_state, :integer, default: 0, null: false
    add_index :orders, :published_state

    add_column :orders, :sync_state, :integer, default: 0, null: false
    add_index :orders, :sync_state

    add_column :orders, :xero_financial_record_state, :integer, default: 0, null: false
    add_index :orders, :xero_financial_record_state

    # :pending, :submitted, :synced, :voided
    # [ :draft, :submitted, :authorized, :paid, :billed, :deleted, :voided ]

    Order.all.each {|o|
      case o.read_attribute(:xero_state)
      when 0
        o.update_column(:xero_financial_record_state, 0)
      when 1
        o.update_column(:xero_financial_record_state, 2)
      when 2
        o.update_column(:xero_financial_record_state, 2)
      when 3
        o.update_column(:xero_financial_record_state, 6)
      end

      case o.read_attribute(:order_state)
      when 0
        o.update_column(:published_state, 0)
      when 1
        o.update_column(:published_state, 1)
      end

      o.update_column(:sync_state, 1)
    }

    remove_column :orders, :xero_state, :integer, default: 0, null: false
    remove_column :orders, :order_state, :integer, default: 0, null: false

    # Credit Notes
    add_column :credit_notes, :sync_state, :integer, default: 0, null: false
    add_index :credit_notes, :sync_state

    add_column :credit_notes, :xero_financial_record_state, :integer, default: 0, null: false
    add_index :credit_notes, :xero_financial_record_state

    CreditNote.all.each {|cn|
      case cn.read_attribute(:xero_state)
      when 0
        cn.update_column(:xero_financial_record_state, 0)
      when 1
        cn.update_column(:xero_financial_record_state, 2)
      when 2
        cn.update_column(:xero_financial_record_state, 2)
      when 3
        cn.update_column(:xero_financial_record_state, 6)
      end

      cn.update_column(:sync_state, 1)
    }

    remove_column :credit_notes, :xero_state, :integer, default: 0, null: false
  end

  def down
    add_column :orders, :xero_state, :integer, default: 0, null: false
    add_index :orders, :xero_state

    add_column :orders, :order_state, :integer, default: 0, null: false
    add_index :orders, :order_state

    # :pending, :submitted, :synced, :voided
    # [ :draft, :submitted, :authorized, :paid, :billed, :deleted, :voided ]

    Order.all.each {|o|
      case o.read_attribute(:xero_financial_record_state)
      when 0
        o.update_column(:xero_state, 0)
      when 1
        o.update_column(:xero_state, 0)
      when 2
        o.update_column(:xero_state, 2)
      when 3
        o.update_column(:xero_state, 2)
      when 4
        o.update_column(:xero_state, 2)
      when 5
        o.update_column(:xero_state, 3)
      when 6
        o.update_column(:xero_state, 3)
      end
    }

    remove_column :orders, :published_state
    remove_column :orders, :sync_state
    remove_column :orders, :xero_financial_record_state

    # Credit Notes
    add_column :credit_notes, :xero_state, :integer, default: 0, null: false
    add_index :credit_notes, :xero_state

    CreditNote.all.each {|cn|
      case cn.read_attribute(:xero_financial_record_state)
      when 0
        cn.update_column(:xero_state, 0)
      when 1
        cn.update_column(:xero_state, 0)
      when 2
        cn.update_column(:xero_state, 2)
      when 3
        cn.update_column(:xero_state, 2)
      when 4
        cn.update_column(:xero_state, 2)
      when 5
        cn.update_column(:xero_state, 3)
      when 6
        cn.update_column(:xero_state, 3)
      end
    }

    remove_column :credit_notes, :sync_state
    remove_column :credit_notes, :xero_financial_record_state
  end
end
