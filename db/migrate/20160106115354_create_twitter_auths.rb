class CreateTwitterAuths < ActiveRecord::Migration
  def change
    create_table :twitter_auths do |t|
      t.text :message
      t.string :message_url
      t.string :image
      t.string :redirect_url

      t.timestamps
    end
  end
end
