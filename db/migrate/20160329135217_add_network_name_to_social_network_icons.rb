class AddNetworkNameToSocialNetworkIcons < ActiveRecord::Migration
  def change
    add_column :social_network_icons, :network_name, :string
  end
end
