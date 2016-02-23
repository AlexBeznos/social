class RemoveWithMessageFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :with_message_type
  end
end
