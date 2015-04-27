class CreateCostumers < ActiveRecord::Migration
  def change
    create_table :costumers do |t|
      t.integer :network
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

      t.timestamps
    end
  end
end
