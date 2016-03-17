class RemoveUrlFromStocks < ActiveRecord::Migration
  def self.up
    remove_column :stocks, :url
  end

  def self.down
    add_column :stocks, :url, :string
  end
end
