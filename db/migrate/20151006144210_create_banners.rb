class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :name
      t.integer :number_of_views, :null => false, :default => 0
      t.integer :place_id
      t.attachment :content  
      t.timestamps
    end
    add_index :banners, :place_id
  end
end