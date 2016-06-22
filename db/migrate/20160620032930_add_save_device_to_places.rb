class AddSaveDeviceToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :save_device, :boolean, default: false
  end
end
