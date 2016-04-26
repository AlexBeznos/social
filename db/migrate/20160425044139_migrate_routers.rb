class MigrateRouters < ActiveRecord::Migration
  def self.up
    Place.find_each do |place|
      Router.create!(
        place: place,
        hp_username: place.wifi_username,
        hp_password: place.wifi_password 
      )
    end
  end

  def self.down
  end
end
