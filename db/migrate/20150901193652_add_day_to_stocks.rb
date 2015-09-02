class AddDayToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :day, :string
  end
end
