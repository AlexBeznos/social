class ChangeWithMessageIdToPlaceId < ActiveRecord::Migration
  def self.up
    rename_column :messages, :with_message_id, :place_id
  end

  def self.down
    rename_column :messages, :place_id, :with_message_id
  end
end
