class CreateCustomerSession < ActiveRecord::Migration
  def change
    create_table :customer_sessions do |t|
      t.integer :device_id, index: true
      t.integer :place_id, index: true
      t.integer :customer_id, index: true
      t.string :auth_step, default: "primary"
      t.string :redirect_url
    end
  end
end
