class CreateAuths < ActiveRecord::Migration
  def change
    create_table :auths do |t|
      t.string :resource_type
      t.integer :resource_id
      t.integer :place_id
      t.string :redirect_url
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :auths, :resource_id
    add_index :auths, :place_id
  end
end
