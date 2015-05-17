class AddBackgroundToPlaces < ActiveRecord::Migration
  def self.up
    add_column     :places, :background_active, :boolean
    add_attachment :places, :mobile_image
    add_attachment :places, :tablet_image
    add_attachment :places, :desktop_image
  end

  def self.down
    remove_column     :places, :background_active, :boolean
    remove_attachment :places, :mobile_image
    remove_attachment :places, :tablet_image
    remove_attachment :places, :desktop_image
  end
end
