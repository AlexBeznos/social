class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.text :question
      t.integer :place_id
      t.timestamps
    end
    add_index :polls, :place_id
  end
end
