class AddFieldsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :subscription, :string
    add_column :messages, :subscription_uid, :string
  end
end
