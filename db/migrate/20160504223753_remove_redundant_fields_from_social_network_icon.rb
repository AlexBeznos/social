class RemoveRedundantFieldsFromSocialNetworkIcon < ActiveRecord::Migration
  def change
    remove_column :social_network_icons, :icon_content_type
    remove_column :social_network_icons, :icon_updated_at
    remove_column :social_network_icons, :icon_file_size
    remove_column :social_network_icons, :social_network_id
  end
end
