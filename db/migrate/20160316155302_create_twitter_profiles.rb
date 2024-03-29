class CreateTwitterProfiles < ActiveRecord::Migration
  def change
    create_table :twitter_profiles do |t|
      t.string :name
      t.string :url
      t.string :uid
      t.string :access_token
      t.string :access_token_secret

      t.date :expiration_date
      t.integer :friends_count

      t.timestamps
    end
  end
end
