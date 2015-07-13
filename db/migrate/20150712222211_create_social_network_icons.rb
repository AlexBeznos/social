class CreateSocialNetworkIcons < ActiveRecord::Migration
  def change
    create_table :social_network_icons do |t|
      t.integer :place_id
      t.attachment :icon
      t.integer :social_network_id
      t.integer :style_id

      t.timestamps
    end
    add_index :social_network_icons, :place_id
    add_index :social_network_icons, :style_id
    add_index :social_network_icons, :social_network_id
  end
end
