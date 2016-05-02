class CreateNotificationRules < ActiveRecord::Migration
  def change
    create_table :notification_rules do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.belongs_to :location
      t.boolean :enabled

      t.timestamps null: false
    end
  end
end
