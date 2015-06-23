class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.attachment :image
      t.string :url
      t.integer :place_id

      t.timestamps
    end
    
    add_index :stocks, :place_id
  end
end
