class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :order, index: true, foreign_key: true
      t.references :credit_note, index: true, foreign_key: true
      t.references :notification_rule, index: true, foreign_key: true, null: false
      t.datetime :processed_at
      t.integer :notification_state, default: 0, null: false

      t.timestamps null: false
    end
  end
end
