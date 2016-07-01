class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :mac_address
      t.datetime :remembering_expires_at
    end
  end
end
