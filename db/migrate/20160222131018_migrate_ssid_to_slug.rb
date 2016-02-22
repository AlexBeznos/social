class MigrateSsidToSlug < ActiveRecord::Migration
  def self.up
    update "UPDATE places SET ssid = slug"
  end

  def self.down
  end
end
