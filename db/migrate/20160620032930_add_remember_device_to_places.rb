class AddRememberDeviceToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :remember_device, :boolean, default: false
  end
end
