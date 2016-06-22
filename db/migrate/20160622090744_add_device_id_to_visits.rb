class AddDeviceIdToVisits < ActiveRecord::Migration
  def change
    add_column :customer_visits, :device_id, :integer, index: true
  end
end
