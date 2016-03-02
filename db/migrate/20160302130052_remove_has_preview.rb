class RemoveHasPreview < ActiveRecord::Migration
  def change
    remove_column :places, :has_preview
  end
end
