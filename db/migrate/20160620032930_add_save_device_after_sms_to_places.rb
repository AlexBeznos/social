class AddSaveDeviceAfterSmsToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :save_device_after_sms, :boolean, default: false
  end
end
