class StandingOrders < ActiveRecord::Migration
  def up
    create_table :order_templates do |t|
      t.date :start_date, null: false
      t.integer :frequency, index: true, default: 1, null: false
      t.references :location, index: true, foreign_key: true, null: false
      t.timestamps null: false
    end

    create_table :order_template_items do |t|
      t.references :order_template, index: true, foreign_key: true, null: false
      t.references :item, index: true, foreign_key: true, null: false
      t.decimal :quantity, default: 0.0, null: false
      t.timestamps null: false
    end

    create_table :order_template_days do |t|
      t.references :order_template, index: true, foreign_key: true, null: false
      t.integer :day, index: true, null: false
      t.boolean :enabled, index: true, default: false, null: false
      t.timestamps null: false
    end
  end

  def down
    drop_table :order_template_items
    drop_table :order_template_days
    drop_table :order_templates
  end
end
