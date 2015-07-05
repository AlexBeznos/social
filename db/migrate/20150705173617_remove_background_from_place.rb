class RemoveBackgroundFromPlace < ActiveRecord::Migration
  def self.up
    drop_attached_file :places, :desktop_image
    drop_attached_file :places, :tablet_image
    drop_attached_file :places, :mobile_image

    remove_column :places, :background_active
  end

  def self.down
    add_attachment :places, :desktop_image
    add_attachment :places, :tablet_image
    add_attachment :places, :mobile_image

    add_column :places, :background_active, :boolean
  end
end
