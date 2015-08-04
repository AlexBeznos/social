class AddSimpleEnterToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :simple_enter, :boolean, default: false
  end
end
