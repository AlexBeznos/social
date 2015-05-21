class CreateCostumers < ActiveRecord::Migration
  def change
    create_table :costumers do |t|
      t.string :name
      t.string :s_name
      t.string :url
      t.string :uid
      t.integer :friends_count
      t.string :gender
      t.string :age
      t.string :b_date
      t.string :city
      t.string :country
      t.integer :social_network_id
      t.string :access_token
      t.string :access_token_secret
      t.datetime :expiration_date

      t.timestamps
    end

    add_index :costumers, :social_network_id
  end
end
