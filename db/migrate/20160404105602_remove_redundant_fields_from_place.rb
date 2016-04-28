class RemoveRedundantFieldsFromPlace < ActiveRecord::Migration
  def self.up
    remove_column :places, :wifi_settings_link_not_fresh
    rename_column :places, :wifi_settings_link, :router_settings
  end

  def self.down
  end
end
