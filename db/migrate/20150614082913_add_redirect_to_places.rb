class AddRedirectToPlaces < ActiveRecord::Migration
  def self.up
    add_column :places, :redirect_url, :string
    remove_column :messages, :redirect_link
  end

  def self.down
    add_column :messages, :redirect_link, :string
    remove_column :places, :redirect_url
  end
end
