class RemoveGowifiSmsTable < ActiveRecord::Migration
  def self.up
    drop_table :gowifi_sms
  end

  def self.down
  end
end
