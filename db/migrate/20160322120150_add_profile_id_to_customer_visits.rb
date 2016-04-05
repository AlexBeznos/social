class AddProfileIdToCustomerVisits < ActiveRecord::Migration
  def change
    add_column :customer_visits, :profile_id, :integer
    add_index :customer_visits, :profile_id
  end
end
