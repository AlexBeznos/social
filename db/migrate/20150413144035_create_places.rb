class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :slug
      t.integer :user_id
      t.boolean :enter_by_password
      t.string :password
      t.boolean :active

      t.timestamps
    end
  end
end
