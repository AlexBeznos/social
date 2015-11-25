class AddPlaceGroupsToMessages < ActiveRecord::Migration
  def change
    rename_column :messages, :place_id, :with_message_id
    add_column :messages, :with_message_type, :string, default: "Place"  
  end
end
