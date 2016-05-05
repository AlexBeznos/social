class DropNetworkProfiles < ActiveRecord::Migration
  def self.up
    drop_table :customer_network_profiles
  end

  def self.down
  end
end
