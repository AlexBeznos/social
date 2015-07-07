class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.text :js
      t.text :js_min
      t.text :css
      t.text :css_min
      t.string :text_color
      t.string :greating_color
      t.attachment :background
      t.integer :place_id

      t.timestamps
    end

    add_index :styles, :place_id
  end
end
