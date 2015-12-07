class CreatePlaceGroups < ActiveRecord::Migration
  def change
    create_table :place_groups do |t|
      t.string :name
      t.references :user, index: true
      t.timestamps
    end
  end
end
