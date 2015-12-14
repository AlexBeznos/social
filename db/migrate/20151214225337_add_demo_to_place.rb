class AddDemoToPlace < ActiveRecord::Migration
  def change
    add_column :places, :demo, :boolean, default: false
  end
end
