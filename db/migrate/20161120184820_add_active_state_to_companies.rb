class AddActiveStateToCompanies < ActiveRecord::Migration[4.2]
  def change
    add_column :companies, :active_state, :integer, default: 0, null: false
    add_index :companies, :active_state
  end
end
