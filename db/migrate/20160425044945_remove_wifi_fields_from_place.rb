class RemoveWifiFieldsFromPlace < ActiveRecord::Migration
  def change
    remove_column :places, :wifi_username
    remove_column :places, :wifi_password
  end
end
