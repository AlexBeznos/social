class AddStockToPlace < ActiveRecord::Migration
  def change
    add_column :places, :stocks_active, :boolean, :default => false
  end
end
