class RemoveSmsAuthFromPlaces < ActiveRecord::Migration
  def self.up
    remove_column :places, :sms_auth
  end

  def self.down
    add_column :places, :sms_auth, :boolean, default: false
  end
end
