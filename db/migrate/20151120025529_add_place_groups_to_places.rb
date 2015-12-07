class AddPlaceGroupsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :place_group_id, :integer
    add_index :places, :place_group_id
  end
end
