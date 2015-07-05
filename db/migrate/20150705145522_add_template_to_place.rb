class AddTemplateToPlace < ActiveRecord::Migration
  def change
    add_column :places, :template, :string, :default => 'default'
  end
end
