class CreateFacebookAuths < ActiveRecord::Migration
  def change
    create_table :facebook_auths do |t|
      t.text :message
      t.string :message_url
      t.string :image
      t.string :redirect_url
      t.integer :place_id

      t.timestamps
    end

    add_index :facebook_auths, :place_id
  end
end
