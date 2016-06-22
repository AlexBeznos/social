class CreateCustomerSession < ActiveRecord::Migration
  def change
    create_table :customer_sessions do |t|
      t.integer :profile_id, index: true
      t.integer :customer_id, index: true
      t.string :step
      t.string :redirect_url
    end
  end
end
