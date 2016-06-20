class CreateJoinTableDevicesToCustomers < ActiveRecord::Migration
  def change
    create_join_table :devices, :customers do |t|
      t.index [:device_id, :customer_id]
      t.index [:customer_id, :device_id]
    end
  end
end
