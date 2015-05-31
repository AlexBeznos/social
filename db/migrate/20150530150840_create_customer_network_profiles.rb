class CreateCustomerNetworkProfiles < ActiveRecord::Migration
  def change
    create_table :customer_network_profiles do |t|
      t.integer :social_network_id
      t.integer :customer_id
      t.integer :friends_count
      t.string :access_token
      t.string :access_token_secret
      t.datetime :expiration_date
      t.string :url
      t.string :uid

      t.timestamps
    end
  end
end
