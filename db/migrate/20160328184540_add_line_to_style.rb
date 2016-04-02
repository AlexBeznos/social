class AddLineToStyle < ActiveRecord::Migration
  def change
    add_column :styles, :line, :string, default: '0, 0, 0, 0.0'
  end
end
