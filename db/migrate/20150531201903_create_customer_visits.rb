class CreateCustomerVisits < ActiveRecord::Migration
  def change
    create_table :customer_visits do |t|
      t.integer :customer_network_profile_id
      t.integer :place_id
      t.integer :customer_id
      t.boolean :by_password, :default => false

      t.timestamps
    end

    add_index :customer_visits, :customer_network_profile_id
    add_index :customer_visits, :place_id
    add_index :customer_visits, :customer_id
    add_index :customer_visits, :created_at
  end
end
