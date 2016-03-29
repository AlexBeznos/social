class AddScratchpadToPlace < ActiveRecord::Migration
  def change
    add_column :places, :scratchpad, :boolean, default: false
  end
end
