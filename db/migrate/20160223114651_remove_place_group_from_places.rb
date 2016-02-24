class RemovePlaceGroupFromPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :place_group_id
  end
end
