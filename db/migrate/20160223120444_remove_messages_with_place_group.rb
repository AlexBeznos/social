class RemoveMessagesWithPlaceGroup < ActiveRecord::Migration
  def self.up
    Message.where(with_message_type: 'PlaceGroup').destroy_all
  end

  def self.down
  end
end
