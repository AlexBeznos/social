class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :resource_type
      t.integer :resource_id
      t.integer :customer_id

      t.timestamps
    end

    add_index :profiles, :resource_id
    add_index :profiles, :customer_id
    add_index :profiles, :resource_type
  end
end
