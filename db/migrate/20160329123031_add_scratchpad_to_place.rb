class AddScratchcardToPlace < ActiveRecord::Migration
  def change
    add_column :places, :scratchcard, :boolean, default: false
  end
end
