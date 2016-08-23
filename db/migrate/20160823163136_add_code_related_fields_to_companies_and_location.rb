class AddCodeRelatedFieldsToCompaniesAndLocation < ActiveRecord::Migration
  def up
    add_column :companies, :location_code_prefix, :string, limit: 10
    add_column :locations, :code, :string, limit: 10

    Company.all.each do |c|
      c.save
      p "#{c.location_code_prefix} - #{c.id}"
    end

    Location.all.each do |l|
      l.save
      p l.code
    end

    change_column :companies, :location_code_prefix, :string, limit: 10, null: false
    change_column :locations, :code, :string, limit: 10, null: false

    add_index :companies, :location_code_prefix, unique: true
    add_index :locations, :code, unique: true
  end

  def down
    remove_column :companies, :location_code_prefix, :string
    remove_column :locations, :code, :string
  end
end
