class AddLineToStyle < ActiveRecord::Migration
  def change
    add_column :styles, :line_colors, :string, default: 'rgba(0, 0, 0, 0.0)'
  end
end
