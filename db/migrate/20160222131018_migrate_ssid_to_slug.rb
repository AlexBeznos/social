class MigrateSsidToSlug < ActiveRecord::Migration
  def self.up
    Place.find_each do |place|
      place.update(ssid: place.slug)
    end
  end

  def self.down
  end
end
