class AddWifiUsernameToPlace < ActiveRecord::Migration
  def change
    add_column :places, :wifi_username, :string, :default => 'P8uDratA'
    add_column :places, :wifi_password, :string, :default => 'Tac4edrU'
    add_column :places, :wifi_settings_link, :string
    add_column :places, :wifi_settings_link_not_fresh, :boolean, :default => true
  end
end
