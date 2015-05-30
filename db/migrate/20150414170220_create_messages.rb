class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.attachment :image
      t.string :redirect_link
      t.text :message
      t.string :message_link
      t.integer :place_id
      t.boolean :active
      t.string :subscription
      t.string :subscription_uid
      t.integer :social_network_id


      t.timestamps
    end

    add_index :messages, :social_network_id
    add_index :messages, :place_id
  end
end
