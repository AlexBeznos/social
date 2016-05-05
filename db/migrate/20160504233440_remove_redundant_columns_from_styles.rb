class RemoveRedundantColumnsFromStyles < ActiveRecord::Migration
  def change
    remove_column :styles, :background_content_type
    remove_column :styles, :background_file_size
    remove_column :styles, :background_updated_at
  end
end
