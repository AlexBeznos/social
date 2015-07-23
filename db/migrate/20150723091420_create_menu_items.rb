class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.references :place, index: true
      t.integer :items_count, default: 0

      t.timestamps
    end
  end
end
