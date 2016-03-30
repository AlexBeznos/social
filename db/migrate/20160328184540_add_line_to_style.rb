class AddLineToStyle < ActiveRecord::Migration
  def change
    add_column :styles, :line, :boolean, default: false
    add_column :styles, :line_background_color, :string, default: '0, 0, 0, 0.5'
  end
end
