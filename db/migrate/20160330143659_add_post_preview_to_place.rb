class AddPostPreviewToPlace < ActiveRecord::Migration
  def change
    add_column :places, :post_preview, :boolean, default: false
  end
end
