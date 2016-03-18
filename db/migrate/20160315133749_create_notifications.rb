class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :source, polymorphic: true, index: true
      t.integer :user_id
      t.string  :category
      t.timestamps null: false
    end

    add_index "notification", ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end
end
