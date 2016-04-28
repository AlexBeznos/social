class AddAccountToCustomerVisits < ActiveRecord::Migration
  def change
    add_column :customer_visits, :account_id, :integer
    add_column :customer_visits, :account_type, :string

    add_index :customer_visits, [:account_type, :account_id]
  end
end
