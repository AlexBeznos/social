class AddPreviewPageToPlace < ActiveRecord::Migration
  def change
    add_column :places, :preview_redirect_url, :string
  end
end
