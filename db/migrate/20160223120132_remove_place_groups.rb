class RemovePlaceGroups < ActiveRecord::Migration
  def change
    drop_table :place_groups
  end
end
