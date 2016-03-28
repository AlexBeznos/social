class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :source, polymorphic: true, index: true
      t.integer :user_id
      t.integer :category
      t.timestamps null: false
    end

    add_index :notifications, :user_id
  end
end
