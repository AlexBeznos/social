class RemoveSimpleEnterFromPlaces < ActiveRecord::Migration
  def self.up
    remove_column :places, :simple_enter
  end

  def self.down
    add_column :places, :simple_enter, :boolean, default: false
  end
end
