class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :network
      t.attachment :image
      t.string :redirect_link
      t.text :message
      t.string :message_link
      t.integer :place_id
      t.boolean :active

      t.timestamps
    end
  end
end
