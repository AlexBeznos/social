class RemoveCustomerNetworkProfileFromCustomerVisit < ActiveRecord::Migration
  def change
    remove_column :customer_visits, :customer_network_profile_id, :integer
    remove_column :customer_visits, :by_password, :boolean
    remove_column :customer_visits, :by_sms, :boolean
  end
end
