class CreateFacebookAuth < ActiveRecord::Migration
  def change
    create_table :facebook_auths do |t|
      t.text :message
      t.string :message_url
      t.string :image

      t.timestamps
    end
  end
end
