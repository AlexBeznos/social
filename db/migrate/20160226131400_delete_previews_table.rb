class DeletePreviewsTable < ActiveRecord::Migration
  def up
  drop_table :previews
  end
end
