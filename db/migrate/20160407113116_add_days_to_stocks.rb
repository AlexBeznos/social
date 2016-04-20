class AddDaysToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :days, :text, array: true, default: []
  end
end
