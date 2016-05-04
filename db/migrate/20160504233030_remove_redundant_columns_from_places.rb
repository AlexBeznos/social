class RemoveRedundantColumnsFromPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :logo_content_type
    remove_column :places, :logo_file_size
    remove_column :places, :logo_updated_at
  end
end
