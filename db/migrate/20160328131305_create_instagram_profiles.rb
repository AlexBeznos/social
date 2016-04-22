class CreateInstagramProfiles < ActiveRecord::Migration
  def change
    create_table :instagram_profiles do |t|
      t.string :name
      t.string :nickname
      t.string :url
      t.string :uid
      t.string :access_token

      t.timestamps
    end
  end
end
