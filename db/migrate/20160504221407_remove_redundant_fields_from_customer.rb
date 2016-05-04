class RemoveRedundantFieldsFromCustomer < ActiveRecord::Migration
  def change
    remove_column :customers, :first_name
    remove_column :customers, :last_name
    remove_column :customers, :gender
    remove_column :customers, :age
    remove_column :customers, :birthday
    remove_column :customers, :city
    remove_column :customers, :country
    remove_column :customers, :social_network_id
  end
end
