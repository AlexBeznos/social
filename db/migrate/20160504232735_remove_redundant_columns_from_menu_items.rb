class RemoveRedundantColumnsFromMenuItems < ActiveRecord::Migration
  def change
    remove_column :menu_items, :image_content_type
    remove_column :menu_items, :image_file_size
    remove_column :menu_items, :image_updated_at
  end
end
