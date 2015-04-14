class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :slug
      t.integer :user_id
      t.boolean :enter_by_password, :default => false
      t.string :password
      t.boolean :active, :default => false

      t.timestamps
    end
  end
end
