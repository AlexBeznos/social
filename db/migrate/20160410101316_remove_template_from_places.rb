class RemoveTemplateFromPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :template
  end
end
