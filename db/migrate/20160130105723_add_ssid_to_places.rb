class AddSsidToPlaces < ActiveRecord::Migration
   def change
     add_column :places, :ssid, :string
   end
end
