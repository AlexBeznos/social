class RemoveRedirectUrlFromPlaces < ActiveRecord::Migration
  def self.up
    remove_column :places, :redirect_url
  end

  def self.down
    add_column :places, :redirect_url, :string
  end
end
