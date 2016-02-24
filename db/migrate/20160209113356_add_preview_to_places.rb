class AddPreviewToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :has_preview, :boolean, :default => false
  end
end
